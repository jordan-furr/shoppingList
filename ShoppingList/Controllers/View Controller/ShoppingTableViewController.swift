//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by Jordan Furr on 3/6/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController{

    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.shared.fetchedResultsController.delegate = self
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ItemController.shared.fetchedResultsController.sections?.count ?? 0
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
        let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.setItem(item: item, isComplete: item.isComplete)
        return cell
    }
    
    //MARK: Editing rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
            ItemController.shared.remove(item: item)
        }
    }
    
    
    //MARK: IB ACTIONS (ALERT)
    @IBAction func addTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: { (textfield: UITextField!) -> Void in
            textfield.placeholder = "Enter New Item"
        })
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    let newName = textField.text
                    ItemController.shared.add(itemwithName: newName ?? "")
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Cell Style
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "Unfinished"
        default:
            return "Finished"
        }
    }
    
    
}

extension ShoppingTableViewController: ItemTableViewCellDelegate {
    func tappedButton(for cell: ItemTableViewCell) {
        guard let item = cell.item else { return }
        ItemController.shared.toggleisComplete(item: item)
        cell.updateButton(isComplete: item.isComplete)
        tableView.reloadData()
        
    }
}

extension ShoppingTableViewController: NSFetchedResultsControllerDelegate{

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {break}
        tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let indexPath = newIndexPath else {break}
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .move:
             guard let oldindexPath = indexPath, let newIndexPath = newIndexPath else {break}
             tableView.moveRow(at: oldindexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            print("error")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            print("error")
        }
    }
}
