//
//  TruckDetailViewController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class TruckDetailViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - IBOutlets -
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var hoursOfOperationTextField: UITextField!
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    @IBOutlet weak var truckNameTextField: UITextField!
    @IBOutlet weak var truckImageView: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
