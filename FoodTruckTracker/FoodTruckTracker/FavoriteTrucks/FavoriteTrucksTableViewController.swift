//
//  FavoriteTrucksTableViewController.swift
//  FoodTruckTracker
//
//  Created by Josh Kocsis on 8/26/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTrucksTableViewController: UITableViewController {

    private let apiController = APIController()
    var truck: Truck?
    let reuseIdentifier = "FavoriteTrucks"

    lazy var fetchedResultsController: NSFetchedResultsController<Truck> = {
        let fetchRequest: NSFetchRequest<Truck> = Truck.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "truckName", ascending: true)
        ]

        let context = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController<Truck>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Failed to fetch: \(error)")
        }
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)


        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let truck = fetchedResultsController.object(at: indexPath)
            DispatchQueue.main.async {
                let context = CoreDataStack.shared.mainContext
                context.delete(truck)
                do {
                    try context.save()
                } catch {
                    NSLog("Error saving after deleting: \(error)")
                }
                context.reset()
            }
        }
    }

    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "TruckDetail":
//            if let detailVC = segue.destination as? TruckDetailViewController,
//                let indexPath = tableView.indexPathForSelectedRow {
//                detailVC. = fetchedResultsController.object(at: indexPath)
//                detailVC.apiController = apiController
//            }
//        default:
//            break
//        }
//    }
}

extension FavoriteTrucksTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
