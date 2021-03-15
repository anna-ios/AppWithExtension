//
//  CoreDataManager.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 07.03.2021.
//

import Foundation
import CoreData

class CoreDataManager {
	
	static let instance = CoreDataManager()
		
	init() {
	}
	
	func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Suffixes")
		let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		return fetchedResultsController
	}
	
	private lazy var managedObjectModel: NSManagedObjectModel? = {
		guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
			return nil
		}
		return NSManagedObjectModel(contentsOf: modelURL)
	}()
	
	private var persistanceStoreURL: NSURL {
		let storeName = "DataModel.sqlite"
		let fileManager = FileManager.default
		let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		return documentsDirectoryURL.appendingPathComponent(storeName) as NSURL
	}
	
	private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		guard let managedObjectModel = self.managedObjectModel else {
			return nil
		}
		let persistanceStoreURL = self.persistanceStoreURL
		let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		do {
			let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
													 configurationName: nil,
													 at: persistanceStoreURL as URL,
													 options: options)
				return persistentStoreCoordinator
			} catch {
				let error = error as NSError
				print("\(error.localizedDescription)")
			}
		return persistentStoreCoordinator
	}()
	
	private lazy var privateManagedObjectContext : NSManagedObjectContext = {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
		return managedObjectContext
	} ()
	
	private(set) lazy var managedObjectContext : NSManagedObjectContext = {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.parent = self.privateManagedObjectContext
		return managedObjectContext
	}()
	
	func saveContext () {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
}
