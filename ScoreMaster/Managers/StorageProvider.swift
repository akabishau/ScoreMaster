//
//  StorageProvider.swift
//  ScoreMaster
//
//  Created by Aleksey Kabishau on 4/12/23.
//

import CoreData
import UIKit

class StorageProvider {
	
	private let persistentContainer: NSPersistentContainer
	
	private(set) lazy var context: NSManagedObjectContext = {
		return persistentContainer.viewContext
	}()
	
	
	init(modelName: String) {
		self.persistentContainer = NSPersistentContainer(name: modelName)
		persistentContainer.loadPersistentStores { storeDescription, error in
			if let error = error {
				fatalError("Core Data store failed to load with error: \(error)")
			}
		}
		setUpNotificationHandling()
	}
	
	//TODO: - Add system notifications to save the data
	private func setUpNotificationHandling() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.willTerminateNotification, object: nil)
		//TODO: do I need this option (based on future app flow)
		notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
		
	}
	
	@objc private func saveChanges(_ notification: Notification) {
		saveChanges()
	}
	
	//MARK: - Saving Data
	
	public func saveChanges() {
		print(#function)
		
		guard context.hasChanges else { return }
		do {
			try context.save()
		} catch {
			print("Unable to Save Managed Object Context")
			print("\(error), \(error.localizedDescription)")
		}
	}
}
