//
//  Persistence.swift
//  SwiftCal
//
//  Created by Julian Schenkemeyer on 05.09.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
	
	let databaseName = "SwiftCal.sqlite"
	var oldStoreUrl: URL {
		let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
		return directory.appendingPathComponent(databaseName)
	}
	
	var sharedStoreUrl: URL {
		let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.jschenkemeyer.demo.SwiftCal")!
		return container.appendingPathComponent(databaseName)
	}

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
		
		let startingDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        for i in 0..<30 {
            let newItem = Day(context: viewContext)
			newItem.date = Calendar.current.date(byAdding: .day, value: i, to: startingDate)
			newItem.didStudy = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftCal")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		} else if !FileManager.default.fileExists(atPath: oldStoreUrl.path) {
			container.persistentStoreDescriptions.first!.url = sharedStoreUrl
		}
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
		migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
	
	func migrateStore(for container: NSPersistentContainer) {
		let coordinator = container.persistentStoreCoordinator
		
		// Prevent migrating the old store twice
		guard let oldStore = coordinator.persistentStore(for: oldStoreUrl) else { return }
		print("🏎 starting migration")
		
		do {
			let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreUrl, type: .sqlite)
			print("🏁")
		} catch {
			fatalError("Unable to migrate to the shared store")
		}
		
		do {
			try FileManager.default.removeItem(at: oldStoreUrl)
			print("🗑")
		} catch {
			fatalError("Unable to remove the old store")
		}
	}
}
