//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import UIKit
import CoreData



enum EndPoints: String {
// App Login endpoints: Complete
case register = "auth/register" // Post
case login = "auth/login" // Post
}

final class APIController {

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
        case noId
        case noRep
        case noEncode
        case otherError
    }

    // MARK: = URL endpoints
    private let baseURL = URL(string: "https://food-truck-lambda.herokuapp.com/api")!
    private lazy var usersURL = baseURL.appendingPathComponent("users")
    private lazy var dinerURL = baseURL.appendingPathComponent("diners")
    private lazy var allTruckWithRatings = baseURL.appendingPathComponent("trucks/")
    private lazy var menuItems = baseURL.appendingPathComponent("menuitems/")
//    /api/menuitems/


    // MARK: = Comletion handlers
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionTruckHandler = (Result<Truck, NetworkError>) -> Void
    typealias CompletionImageHandler = (Result<UIImage, NetworkError>) -> Void
    typealias CompletionStringArrayHandler = (Result<[String], NetworkError>)-> Void

    var bearer: Bearer?

//    // Helper method for posting
    private func postRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    //    Method used for request
       private func request(for endpoint: EndPoints, httpMethod: HTTPMethod) -> URLRequest {
           let url = baseURL.appendingPathComponent(endpoint.rawValue)
           var request = URLRequest(url: url)
           request.httpMethod = httpMethod.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           if let bearer = bearer {
               request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
           }
           return request
       }

    func registerAndLogin(with user: User, endpoint: EndPoints, httpMethod: HTTPMethod, completion: @escaping CompletionHandler = { _ in }) {
        var requests = request(for: endpoint, httpMethod: httpMethod) // change

        do {
            let jsonData = try JSONEncoder().encode(user)
            print(String(data: jsonData, encoding: .utf8)!)
            requests.httpBody = jsonData
        } catch {
            print("Error encodign user: \(error)")
            completion(.failure(.failedSignUp))
        }

        let task = URLSession.shared.dataTask(with: requests) { (data, response, error) in
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

    // Method used to fetch All diners
    func fetchAllDiners(for diner: User, completion: @escaping CompletionStringArrayHandler = { _ in }) {
        var request = URLRequest(url: dinerURL)
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
                let diners = try JSONDecoder().decode([String].self, from: data)
                completion(.success(diners))
            } catch {
                print("Error decoding Users data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

//     Method used to Send truck to Server
    func sendtruckToServer(truck: Truck, completion: @escaping CompletionHandler = {_ in }) {
        let truckId = truck.truckId

        let requestURL = baseURL.appendingPathComponent(String(truckId)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation =  truck.truckRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {

            print("Error encoding task: \(truck), \(error)")
            completion(.failure(.noEncode))
            return
        }

        let entry = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error PUTting task to server: \(error)")
                completion(.failure(.otherError))
                return
            }

            completion(.success(true))
        }
        entry.resume()
    }

    // Method to delete from server.
    func deleteTruckFromServer(_ truck: Truck, completion: @escaping CompletionHandler = { _ in }) {
        let truckId = truck.truckId

        let requestURL = baseURL.appendingPathComponent(String(truckId)).appendingPathExtension("json")
         var request = URLRequest(url: requestURL)
         request.httpMethod = "DELETE"

         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             print(response!)
             completion(.success(true))
         }
         task.resume()
     }

    // Method to send MenuItem to servier post
    func sendMenuItemToServer(menu: MenuItem, completion: @escaping CompletionHandler = {_ in }) {
        let truckId = menu.truckId

        let requestURL = baseURL.appendingPathComponent(String(truckId)).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation =  menu.menuRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {

            print("Error encoding task: \(menu), \(error)")
            completion(.failure(.noEncode))
            return
        }

        let entry = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error PUTting task to server: \(error)")
                completion(.failure(.otherError))
                return
            }

            completion(.success(true))
        }
        entry.resume()
    }

    // Method to delete MenuItem form servie delete
    func deleteMenuFromServer(_ menu: MenuItem, completion: @escaping CompletionHandler = { _ in }) {
        let truckId = menu.truckId

        let requestURL = baseURL.appendingPathComponent(String(truckId)).appendingPathExtension("json")
         var request = URLRequest(url: requestURL)
         request.httpMethod = "DELETE"

         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             print(response!)
             completion(.success(true))
         }
         task.resume()
     }

    //    Method used to fetch Truck details
    func fetchAllTrucksWithRating(for truckName: String, completion: @escaping CompletionStringArrayHandler = { _ in }) {

        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }

        var request = URLRequest(url: allTruckWithRatings.appendingPathComponent(truckName))
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
                print("No data recieved from Get all \(truckName)")
                completion(.failure(.noData))
                return
            }

            do {
                let truckRatings = try JSONDecoder().decode([String].self, from: data)
                completion(.success(truckRatings))
            } catch {
                print("Error decoding Trucks Rating  data: \(truckName)): \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    //    Method used to fetch a trucks Image

    func fetchTruckImage(imageOfTruck: URL, completion: @escaping (UIImage?) -> Void) {

        let request = URLRequest(url: imageOfTruck)

        // Check to see if this image has already been cached
            if let urlResponse = URLCache.shared.cachedResponse(for: request) {
                let characterImage = UIImage(data: urlResponse.data)
                completion(characterImage)
                return
            }

            // If not, go ahead and perform the request
            URLSession.shared.dataTask(with: imageOfTruck) { data, response, error in
                if let error = error {
                    print("Error retrieving character image \(error)")
                    completion(nil)
                }

                if let data = data, let response = response {

                    // Then store the response so we don't have to fetch it again next time
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)

                    let characterImage = UIImage(data: data)
                    completion(characterImage)
                }
            }.resume()
        }
}


