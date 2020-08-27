//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//



import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedSignUp
    case failedSignIn
    case noToken
    case tryAgain
}

class APIController {

    // MARK: = URL endpoints
    private let baseURL = URL(string: "https://food-truck-lambda.herokuapp.com/api")!
    private lazy var registerURL = baseURL.appendingPathComponent("auth/register")
    private lazy var logInURL = baseURL.appendingPathComponent("auth/login")
    private lazy var usersURL = baseURL.appendingPathComponent("users")
    private lazy var dinerURL = baseURL.appendingPathComponent("diners")
    private lazy var allTruckWithRatings = baseURL.appendingPathComponent("trucks/")


    // MARK: = Comletion handlers
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionTruckHandler = (Result<Truck, NetworkError>) -> Void
    typealias CompletionImageHandler = (Result<UIImage, NetworkError>) -> Void
    typealias CompletionStringArrayHandler = (Result<[String], NetworkError>)-> Void

    var bearer: Bearer?

    // Helper method for posting
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    // Method to register
    func registerUser(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        var request = postRequest(for: registerURL)
        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Sign Up failed with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign up was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))

            }
            task.resume()
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }

    // Method for login
    func loginUser(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        var request = postRequest(for: logInURL)

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Sign in failed with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        print("Sign in was unsuccessful")
                        completion(.failure(.failedSignIn))
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
                    print("Error decoding berrer: \(error)")
                    completion(.failure(.noToken))
                    return
                }
            }
            task.resume()
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
            completion(.failure(.failedSignIn))
        }
    }

    // Get All Users
    func fetchAllUsers(completion: @escaping CompletionStringArrayHandler = { _ in }) {

        var request = URLRequest(url: usersURL)
        request.httpMethod = HTTPMethod.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving Users data: \(error)")
                completion(.failure(.tryAgain))
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }

            guard let data = data else {
                print("No data recieved from Get all ")
                completion(.failure(.noData))
                return
            }

            do {
                let allUsers = try JSONDecoder().decode([String].self, from: data)
                completion(.success(allUsers))
            } catch {
                print("Error decoding Users data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    //    Method used to fetch Truck details
    func fetchAllTrucksWithRating(completion: @escaping CompletionStringArrayHandler = { _ in }) {

        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }

        var request = URLRequest(url: allTruckWithRatings)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving Trucks Rating data: \(error)")
                completion(.failure(.tryAgain))
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.noToken))
                return
            }

            guard let data = data else {
                print("No data recieved from Get all ")
                completion(.failure(.noData))
                return
            }

            do {
                let truckRatings = try JSONDecoder().decode([String].self, from: data)
                completion(.success(truckRatings))
            } catch {
                print("Error decoding Trucks Rating  data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    //    Method used to fetch a trucks Image

    func fetchTruckImage(at urlString: String, completion: @escaping CompletionImageHandler = { _ in }) {

        let imageURL = URL(string: urlString)!

        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue

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

//    Method used to delete from APImod

}

