//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//
/*


import Foundation
import UIKit

enum HTTPMethods: String {
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

enum EndPoints: String {
    // App Login endpoints: Complete
    case register = "auth/register" // Post
    case login = "auth/login" // Post

    //
    case diners
    case users
    case operators
    case trucks
    case menuitems

    //
    case addfavtruck
    case photos
    case ratings
    case removefavtruck


    case createMenuItems = "api/menuitems" // Post

    // Adding endpoints
    case addDinersFavTruck = "api/diners/addfavtruck" // Post
    case addedPhotoMenuItems = "api/menuitems/:id/photos"// Post


    // Truck
    // endpoint that hadles the Rateing , creating and update
//    case trucks = "api/trucks/:id/ratings"

//    // Fetch data endpoints
//    case getAllUsers = "api/users " // Get
//    case getAllDiner = "api/diners" // Get
//    case getDinerDetial = "api/diners/:id" // Get
//    case getAllOperators = "api/operators" // Get
//    case getOperatorsDetial = "api/operators/:id" // Get
//    case getAllTrucksWithRatings = "api/trucks/"// Get
//    case getTrucksDetials = "api/trucks/:id" // Get
//    case getTruckMenu = "api/trucks/:id/menuitems"// Get
//
//    case getMenuItems = "api/menuitems/" // Get
//    case getMenuItemsDetail = "api/menuitmes/:id" // Get
//    case getTruckRating = "api/menuitmes/:id" // Get
//    case getTruckImages = "api/menuitmes/:id/photos" // Get
//
//    // Update endpoints
//    case updateTrucks = "api/trucks/:id" // Put
//    case updateMenuItemsRating = "api/menuitems/:id/ratings" // Post
//    case updateMenuItems = "api/menuitems/:id" // Put
//
//    // Delete endpoints
//    case deleteDinersFavTruck = "/api/diners/removefavtruck" // Delete
//    case deleteTruck = "api/trucks/:id" //Delete
//    case deleteTruckRating = "api/trucks/ratings/:id" // Delete
//    case deleteMenuItems = "api/menuitems/:id" // Delete
//    case deleteMenuItemsRating = "api/menuitems/ratings/:id " //Delete
//    case deleteMenuItemPhoto = "api/menuitems/photos/:id" // Delete
}

private let baseURL = URL(string: "https://food-truck-lambda.herokuapp.com/api")!

class APIController {

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    typealias CompletionTruckHandler = (Result<Truck, NetworkError>) -> Void
    typealias CompletionImageHandler = (Result<UIImage, NetworkError>) -> Void
    typealias CompletionStringArrayHandler = (Result<[String], NetworkError>)-> Void

    var bearer: String?

    //    Method used for request
    private func request(for endpoint: EndPoints, httpMethod: HTTPMethods) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let bearer = bearer {
            request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    // Method used to login/signup
    func registerAndLogin(with user: User, endpoint: EndPoints, httpMethod: HTTPMethods, completion: @escaping CompletionHandler = { _ in }) {
        var requests = request(for: endpoint, httpMethod: httpMethod) // change

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

    // Method used to Create Truck items
    // Note I need a Truck Representation for the data that will be pass through to the API Conroller
//    func createTruck(with user: User, endpoint: EndPoints,httpMethod: HTTPMethods, completion: @escaping CompletionHandler = { _ in }){
//        var requests = request(for: endpoint, httpMethod: httpMethod)
//
//    }





    //    Method used to fetch Truck details
    func fetchTruckDetail(for truckId: String, completion: @escaping CompletionTruckHandler = { _ in }) {

        let url = baseURL.appendingPathComponent(EndPoints.trucks.rawValue).appendingPathComponent(truckId).appendingPathComponent(EndPoints.photos.rawValue)


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
                print("No data recieved from fetchTruckDetail from trucks: \(truckId)")
                completion(.failure(.noData))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                //                jsonDecoder.dataDecodingStrategy = .base64
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                /*
                 switch endpoint {
                 case
                 }
                 */
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

//    Method used to delete from APImod

}
  */
