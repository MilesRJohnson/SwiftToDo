//
//  Items.swift
//  SwiftToDo
//
//  Created by Miles Johnson on 7/7/15.
//  Copyright (c) 2015 StarShip Enterprise. All rights reserved.
//

import Foundation
import CoreData
@objc(Items)
class Items: NSManagedObject {

    @NSManaged var itemName: String
    @NSManaged var itemDescription: String
    @NSManaged var dateComplete: NSDate
    @NSManaged var dateEntered: NSDate
    @NSManaged var dateUpdated: NSDate
    @NSManaged var itemComplete: NSNumber
    @NSManaged var itemImportance: NSNumber
    @NSManaged var itemDueDate: NSDate
    @NSManaged var itemType: String

}
