//
//  Entity+CoreDataProperties.swift
//  20.6 core data
//
//  Created by Дмитрий Богданов on 19.07.2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var coutnry: String?
    @NSManaged public var firstname: String?
    @NSManaged public var subname: String?

}

extension Entity : Identifiable {

}
