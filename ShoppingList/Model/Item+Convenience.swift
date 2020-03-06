//
//  Item+Convenience.swift
//  ShoppingList
//
//  Created by Jordan Furr on 3/6/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    @discardableResult
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.name = name
    }
}
