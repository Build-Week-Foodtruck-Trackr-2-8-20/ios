//
//  SearchViewController.swift
//  FoodTruckTracker
//
//  Created by Shawn Gee on 8/24/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import CoreData
import UIKit

class SearchViewController: UIViewController {
    // MARK: - Public Properties
    
    var apiController: APIController? {
        didSet {
            mapVC.apiController = apiController
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var resultsContainer: UIView!
    
    // MARK: - Private Properties
    
    private let mapVC: SearchResultsMapViewController = UIStoryboard(name: "SearchResultsMap", bundle: .main).instantiateInitialViewController()!
    private let listVC: SearchResultsListViewController = UIStoryboard(name: "SearchResultsList", bundle: .main).instantiateInitialViewController()!
    
    private var currentResultsVC: SearchResultsViewController?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Truck> = {
        let request: NSFetchRequest<Truck> = Truck.fetchRequest()
        request.sortDescriptors = [
            .init(key: "truckName", ascending: true),
        ]
        
        let context = CoreDataStack.shared.mainContext

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = mapVC
        try? frc.performFetch()
        
        return frc
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildren()
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
    }
    
    // MARK: - Private Methods
    
    private func addChildren() {
        addChild(listVC)
        resultsContainer.addSubview(listVC.view)
        listVC.didMove(toParent: self)
        listVC.view.fillSuperview()
        
        listVC.fetchedResultsController = fetchedResultsController
        currentResultsVC = listVC
        
        addChild(mapVC)
        mapVC.didMove(toParent: self)
        mapVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - IBActions
    
    /// Swaps between the map and list results VCs with a flip transition
    @IBAction func swapViews(_ sender: UIBarButtonItem) {
        guard let currentVC = currentResultsVC else { return }
        let destinationVC: SearchResultsViewController
            
        if currentVC === listVC {
            sender.title = "List"
            destinationVC = mapVC
        } else {
            sender.title = "Map"
            destinationVC = listVC
        }
        
        fetchedResultsController.delegate = destinationVC
        destinationVC.fetchedResultsController = fetchedResultsController
        
        transition(
            from: currentVC,
            to: destinationVC,
            duration: 1.0,
            options: .transitionFlipFromLeft,
            animations: nil,
            completion: nil
        )
        
        destinationVC.view.fillSuperview()
        
        self.currentResultsVC = destinationVC
    }
}

// MARK: - Search Results Updating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate =
            NSPredicate(format: "truckName BEGINSWITH[cd] %@", searchText)
        }
    
        try? fetchedResultsController.performFetch()
        currentResultsVC?.reloadData()
    }
}

// MARK: - Search Results View Controller Protocol

/// Interface for common functionality of child view controllers that display search results
protocol SearchResultsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Truck>? { get set }
    
    func reloadData()
}
extension SearchResultsListViewController: SearchResultsViewController {}
extension SearchResultsMapViewController: SearchResultsViewController {}


extension UIView {
    /// Fills the view's superview completely.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    /// - Precondition: View must be embedded in a superview.
    func fillSuperview(respectingSafeArea: Bool = false) {
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if respectingSafeArea {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])
        }
    }
}
