//
//  SearchViewController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet private var resultsContainer: UIView!
    
    private let mapVC = UIStoryboard(name: "SearchResultsMap", bundle: .main).instantiateInitialViewController()!
    private let listVC = UIStoryboard(name: "SearchResultsList", bundle: .main).instantiateInitialViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(listVC)
        resultsContainer.addSubview(listVC.view)
        listVC.didMove(toParent: self)
        listVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addChild(mapVC)
        mapVC.didMove(toParent: self)
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
    @IBAction func swapViews(_ sender: UIBarButtonItem) {
        let currentVC = listVC.view.isDescendant(of: view) ? listVC : mapVC
        let destinationVC: UIViewController
            
        if currentVC === listVC {
            sender.title = "List"
            destinationVC = mapVC
        } else {
            sender.title = "Map"
            destinationVC = listVC
        }
        
        transition(
            from: currentVC,
            to: destinationVC,
            duration: 1.0,
            options: .transitionFlipFromLeft,
            animations: nil,
            completion: nil
        )
    }
}
