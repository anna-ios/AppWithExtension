//
//  Suffixes+CoreDataClass.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 10.03.2021.
//
//

import Foundation
import CoreData


public class Suffixes: NSManagedObject {
	
	convenience init() {
		// Описание сущности
		let entity = NSEntityDescription.entity(forEntityName: "Suffixes", in: CoreDataManager.instance.managedObjectContext)
		
		// Создание нового объекта
		self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectContext)
	}

}
