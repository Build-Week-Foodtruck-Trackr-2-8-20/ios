//
//  LoginViewController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController, UITextFieldDelegate {

    

    var apiController: APIController?

    @IBOutlet weak var userSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextfField: UITextField!
    @IBOutlet weak var emialTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
