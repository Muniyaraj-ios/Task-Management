//
//  CoreDataManager.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task_Management")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("❌ Failed to load Core Data: \(error.localizedDescription)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("❌ Error saving Core Data: \(error.localizedDescription)")
        }
    }
}

