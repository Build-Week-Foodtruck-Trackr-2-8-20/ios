//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethods: String {
    case get = "GET"
    case post = "Post"
    case put = "Put"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedSignUp
    case failedSignIn
    case noToken
    case tryAgain

}

enum EndPoints: String {
    case register = "auth/register"
    case login = "auth/login"
    case allTrucksWithRatings = "api/trucks/"
    case trucks = "api/trucks/:id"
}

private let baseURL = URL(string: "https://food-truck-lambda.herokuapp.com/api")!

class APIController {

    //    private lazy var getAllTruckRatings = baseURL .appendingPathComponent("/api/trucks/")

    //    private lazy var getTruckRatings = baseURL.appendingPathComponent("/api/trucks/:id/ratings")

    //    private lazy var createTruck = baseURL.appendingPathComponent("/api/trucks")

    //    private lazy var createTruckRating = baseURL.appendingPathComponent("/api/trucks/:id/ratings")

    //    private lazy var getTruckDetails = baseURL.appendingPathComponent("/api/trucks/:id")

    //    private lazy var updateTruck = baseURL.appendingPathComponent("/api/trucks/:id")
    //    private lazy var deleteTruck = baseURL.appendingPathComponent("/api/trucks/:id")

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionTruckHandler = (Result<Truck, NetworkError>) -> Void
    typealias CompletionImageHandler = (Result<UIImage, NetworkError>) -> Void
    typealias CompletionStringArrayHandler = (Result<[String], NetworkError>)-> Void

    var bearer: Bearer?

    //    Method used for posting
    private func postRequest(for endpoint: EndPoints) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func getRequest(for endpoint: EndPoints) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        request.setValue("Bearer \(String(describing: bearer?.token))", forHTTPHeaderField: "Authorization")
        return request
    }

    // Method used to login/signup
    func registerAndLogin(with user: User, endpoint: EndPoints, completion: @escaping CompletionHandler = { _ in }) {
        var request = postRequest(for: endpoint)

        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
        } catch {
            print("Error encodign user: \(error)")
            completion(.failure(.failedSignUp))
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Sign Up failed with error: \(error)")
                completion(.failure(.failedSignIn))
                return
            }

            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    print("Sign up was unsuccessful")
                    completion(.failure(.failedSignUp))
                    return
            }
            guard let data = data else {
                print("Data was not received")
                completion(.failure(.noData))
                return
            }
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                completion(.success(true))
            } catch {
                print("Error decoding bearer: \(error)")
                completion(.failure(.noToken))
                return
            }
        }
        task.resume()
    }

    //    Method used to fetch Truck details
    func fetchTruckDetail(for truckDetial: String, endpoint: EndPoints, completion: @escaping CompletionTruckHandler = { _ in }) {

        let request = postRequest(for: endpoint)

        guard bearer != nil else {
            completion(.failure(.noToken))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error receiving animal detail data: \(error)")
                completion(.failure(.tryAgain))
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }

            guard let data = data else {
                print("No data recieved from fetchTruckDetail from trucks: \(truckDetial)")
                completion(.failure(.noData))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                //                jsonDecoder.dataDecodingStrategy = .base64
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                let truck = try jsonDecoder.decode(Truck.self, from: data)
                completion(.success(truck))
            } catch {
                print("Error decoding truck detial data = \(truckDetial) \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    //    Method used to fetch a trucks Image

    func fetchTruckImage(at urlString: String, completion: @escaping CompletionImageHandler = { _ in }) {
        let imageURL = URL(string: urlString)!

        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethods.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error receiving Truck image: \(urlString), error: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let image = UIImage(data: data)!
            completion(.success(image))
        }
        task.resume()
    }

}
