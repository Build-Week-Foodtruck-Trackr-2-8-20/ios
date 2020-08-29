//
//  MenuViewController.swift
//  FoodTruckTracker
//
//  Created by Rob Vance on 8/25/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var foodItemPrice: UILabel!
    @IBOutlet weak var foodItemPriceTextField: UITextField!
    @IBOutlet weak var foodItemName: UILabel!
    @IBOutlet weak var foodItemTextField: UITextField!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
