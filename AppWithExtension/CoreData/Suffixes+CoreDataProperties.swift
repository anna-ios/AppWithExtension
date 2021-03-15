//
//  Suffixes+CoreDataProperties.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 11.03.2021.
//
//

import Foundation
import CoreData


extension Suffixes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Suffixes> {
        return NSFetchRequest<Suffixes>(entityName: "Suffixes")
    }

    @NSManaged public var array: [String]
    @NSManaged public var creationDate: Date

}

extension Suffixes : Identifiable {

}
