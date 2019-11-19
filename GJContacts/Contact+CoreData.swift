//
//  Contact+CoreData.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation
import CoreData

extension Contact {
  public var fullName: String {
    let seprator = (firstName != nil) ? " " : ""
    return "\(firstName ?? "")\(seprator)\(lastName ?? "")"
  }

  public var sectionTitle: String {
    let firstCharString = firstName?.first?.uppercased() ?? ""
    if firstCharString >= "A" && firstCharString <= "Z" {
      return firstCharString
    }
    return "#"
  }
  
  public class func fetchContactRequest() -> NSFetchRequest<Contact> {
    return NSFetchRequest<Contact>(entityName: "Contact")
  }
  
  public class func getContact(id: Int) -> Contact? {
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id=%ld", id)
    fetchRequest.fetchLimit = 1
    do {
      let contacts: [Contact] = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
      return contacts.first
    } catch {
      print("Unable to fetch contact with id \(id). Error: \(error)")
    }
    return nil
  }
  
  public class func deleteAllContacts() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Contact.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    deleteRequest.resultType = .resultTypeObjectIDs
    
    // perform the delete
    do {
      let managedObjectContext = CoreDataManager.shared.managedObjectContext
      let result = try managedObjectContext.execute(deleteRequest) as? NSBatchDeleteResult
      let managedObjectIds = result?.result as? [NSManagedObjectID] ?? []
      let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: managedObjectIds]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [managedObjectContext])
    } catch let error as NSError {
      print("Unable to delete existing contacts.Error: \(error)")
    }
  }
  
//  func getDetailsMetadata() -> [ContactMetadata] {
//    let phoneMetadata = ContactMetadata(desc: NSLocalizedString("mobile", comment: ""),
//                                        info: phoneNumber, type: .mobile, keyboardType: .phonePad)
//    let emailMetadata = ContactMetadata(desc: NSLocalizedString("email", comment: ""),
//                                        info: email, type: .email, keyboardType: .emailAddress)
//    return [phoneMetadata, emailMetadata]
//  }
//
//  func getEditMetaData() -> [ContactMetadata] {
//    let firstNameMetaData = ContactMetadata(desc: NSLocalizedString("First Name", comment: ""),
//                                            info: firstName, type: .firstName)
//
//    let lastNameMetaData = ContactMetadata(desc: NSLocalizedString("Last Name", comment: ""),
//                                           info: lastName, type: .lastName)
//
//    return [firstNameMetaData, lastNameMetaData] + getDetailsMetadata()
//  }
}

