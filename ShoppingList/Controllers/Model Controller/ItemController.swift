//
//  ItemController.swift
//  ShoppingList
//
//  Created by Jordan Furr on 3/6/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    //MARK: Singleton
    static let shared = ItemController()
    
    //MARK: Source of Truth
    let fetchedResultsController: NSFetchedResultsController<Item> = {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let resultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        return resultsController
    }()
    
    //MARK: Initializer
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data \(error)")
        }
    }
    
    //MARK: CRUD
    func add(itemwithName name: String){
        Item(name: name)
        saveToPersistentStore()
    }
    
    func remove(item: Item){
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the data!!!!! \(#function) \(error.localizedDescription)")
        }
    }
    
    //MARK: Delegate Function
    func toggleisComplete(item: Item){
        item.isComplete = !item.isComplete
        saveToPersistentStore()
    }
}
