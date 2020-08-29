//
//  SignUpViewController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

enum UserType {
    case diners
    case operators
}


import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var apiController: APIController?
    var signUpType = UserType.operators

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
//        if let username = userNameTextField.text,
//            !username.isEmpty,
//            let email = emailTextField.text,
//        !email.isEmpty,
//            let password = passwordTextField.text,
//        !password.isEmpty,
//            let role = userSegmentedControl = userType.diners {
//            let user = User(username: username, password: password, email: email, role: role, id: <#T##Int?#>)
//
//        }
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
