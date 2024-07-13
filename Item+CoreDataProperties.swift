//
//  Item+CoreDataProperties.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 14.07.2024.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var coutnry: String?
    @NSManaged public var firstname: String?
    @NSManaged public var subname: String?

}

extension Item : Identifiable {

}
