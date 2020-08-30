//
//  TruckDetailViewController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit
import CoreData

class TruckDetailViewController: UITabBarController {

    var apiController: APIController?
    var truck: Truck?
    var wasEdited = false
    var truckName: String?
//    let truckImage: (Truck)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
//        getTruckImageDetails()
    }
    

    //MARK: - IBOutlets -

    @IBOutlet weak var hoursOfOperationTextField: UITextField!
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    @IBOutlet weak var truckNameTextField: UITextField!
    @IBOutlet weak var truckImageView: UIImageView!
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let truck = truck else { return }
            cuisineTypeTextField.text = truck.cuisineType
            truckNameTextField.text = truck.truckName
            truckImageView.image = UIImage(named: truck.imageOfTruck ?? "")
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            hoursOfOperationTextField.text = formatter.string(from: truck.departureTime!)
            //apiController.sendTruckToServer(truck: truck)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving truck object context: \(error)")
            }
        }
    }
    
    var truck2 = Truck(cuisineType: "Taco", truckStatus: .arrive, truckName: "Tacos & More", customerRating: 3, customerRatingAvg: 3, departureTime: Date(), imageOfTruck: "", truckLatitude: 44.55, truckLongitude: 44.55, truckId: 23)
    
    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        if editing { wasEdited = true}
//        hoursOfOperationTextField.isUserInteractionEnabled = editing
//        cuisineTypeTextField.isUserInteractionEnabled = editing
//        truckNameTextField.isUserInteractionEnabled = editing
//        truckImageView.isUserInteractionEnabled = editing
    }
    func getTruckDetails() {
//        guard let apiController = apiController else { return }
    }

        
    func getTruckImageDetails() {
        guard let apiController = apiController,
            let truckName = self.truck?.imageOfTruck else { return }
        apiController.fetchTruckImage(at: truckName) { (result) in
            if let truck = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews()
                }
                apiController.fetchTruckImage(at: truckName) { (result) in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.truckImageView.image = image
                        }
                    }
                }
            }
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let truck = truck else { return }
        cuisineTypeTextField.text = truck.cuisineType
        truckNameTextField.text = truck.truckName
        truckImageView.image = UIImage(named: truck.imageOfTruck ?? "")
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        hoursOfOperationTextField.text = formatter.string(from: truck.departureTime!)
        //apiController.sendTruckToServer(truck: truck)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving truck object context: \(error)")
        }
    }
    
    func updateViews() {
//        truckNameTextField.text = truck?.truckName
//        cuisineTypeTextField.text = truck?.cuisineType
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        hoursOfOperationTextField.text = formatter.string(from: (truck?.departureTime)!)
    }
    
}
