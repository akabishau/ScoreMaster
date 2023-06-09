//
//  CoreDataManager.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/6/23.
//

/*
import CoreData
import UIKit

final class CoreDataManager {
	
	private let modelName: String
	
	init(modelName: String) {
		self.modelName = modelName
		setupNotificationHandling()
	}
	
	
	//MARK: - Core Data Stack
	private(set) lazy var managedObjectContext: NSManagedObjectContext = {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator // parent contexts keeps a reference to teh coordinator
		return managedObjectContext
	}()
	
	
	private lazy var managedObjectModel: NSManagedObjectModel = {
		guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
			fatalError("Unable to Find Data Model")
		}
		
		guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
			fatalError("Unable to Load Data Model")
		}
		return managedObjectModel
	}()
	
	
	private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		
		// where to place store - Document dir (also can be Library dir)
		let storeName = "\(self.modelName).sqlite"
		let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let storeURL = documentsDirectoryURL.appendingPathComponent(storeName)
		
		// try to add store to the container
		do {
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
		} catch {
			fatalError("Unable to Add Persistent Store")
		}
		return persistentStoreCoordinator
	}()
	
	
	//MARK: - Saving Data
	
	private func setupNotificationHandling() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.willTerminateNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
		
	}
	
	
	@objc private func saveChanges(_ notification: Notification) {
		saveChanges()
	}
	
	
	private func saveChanges() {
		print(#function)
		
		guard managedObjectContext.hasChanges else { return }
		do {
			try managedObjectContext.save()
		} catch {
			print("Unable to Save Managed Object Context")
			print("\(error), \(error.localizedDescription)")
		}
	}
}
*/
