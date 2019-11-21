//
//  CoreDataManager.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()

  private init() {
  }

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "GJContacts")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      } else {
        print("Store Description \(storeDescription)")
      }
    })
    return container
  }()
  
  var managedObjectContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
