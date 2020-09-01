//
//  SignUpViewController.swift
//  FoodTruckTracker
//
//  Created by Sammy Alvarado on 8/27/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//
import UIKit

enum UserType {
    case diners
    case operators
}

enum LoginType {
    case signUp
    case signIn
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var userSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    var apiController: APIController?
    var signUpType = UserType.operators
    var userType = UserType.diners
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        if let username = userNameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let email = emailTextField.text,
        !email.isEmpty {
            let user = User(username: username, password: password, email: email)

            switch loginType {
            case .signUp:
                apiController?.registerAndLogin(with: user, endpoint: .register, httpMethod: .post, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentControl.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signign up: \(error)")
                    }
                })
            case .signIn:
                apiController?.registerAndLogin(with: user, endpoint: .login, httpMethod: .post, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? APIController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                print("Sign in Failed")
                            case .noData, .noToken:
                                print("No data received")
                            default:
                                print("other errro Occurred")
                            }
                        }
                    }
                })
            }
        }
//                if let username = userNameTextField.text,
//                    !username.isEmpty,
//                    let email = emailTextField.text,
//                !email.isEmpty,
//                    let password = passwordTextField.text,
//                    !password.isEmpty {
//                    let user = User(username: username, password: email, email: password)
//
//                    switch userType {
//                    case .diners:
//                        apiController?.registerAndLogin(with: user, endpoint: .register, httpMethod: .post, completion: { (result) in
//
//                        })
//                    default:
//                        break
//                    }
//                }
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
