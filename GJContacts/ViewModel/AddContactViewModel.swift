//
//  AddContactViewModel.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/21/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation
import CoreData

class AddContactViewModel {
  private var httpClient: HTTPClient!
  private var editMode: Bool!
  
  let doneBarButtonTitle = NSLocalizedString("Done", comment: "")
  let cancelBarButtonTitle = NSLocalizedString("Cancel", comment: "")
  let managedObjectContext = CoreDataManager.shared.managedObjectContext
  
  var contact: Bindable<Contact>!
  var contactMetadata: [ContactDetaildata]!
  var isBusy: Bindable<Bool> = Bindable(false)
  var isContactSync: Bindable<Bool> = Bindable(false)
  var error: Bindable<ErrorExtension?> = Bindable(nil)
  
  init(contact: Contact?, client: HTTPClient? = nil) {
    self.httpClient = client ?? HTTPClient.shared
    
    if let contact = contact {
      editMode = true
      self.contact = Bindable(contact)
      self.contactMetadata = self.contact.value.getEditMetaData()
    } else {
      editMode = false
      guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext) else {
        fatalError("Failed to decode Contact")
      }
      
      self.contact = Bindable(Contact(entity: entity, insertInto: nil))
      self.contactMetadata = self.contact.value.getEditMetaData()
    }
  }
  
  func syncContact() {
    //Validate Contact
    if !validateContact() { return }
    
    var request: APIProtocol = ContactWebService.addContact(contact: contact.value)
    if editMode {
      request = ContactWebService.updateContact(id: Int(contact.value.id), contact: contact.value)
    }
    
    isBusy.value = true
    httpClient.dataTask(request) { [weak self] (result) in
      guard let self = self else {
        return
      }
      
      self.isBusy.value = false
      switch result {
      case .success(let data):
        guard let data = data else {
          return
        }
        
        do {
          let contact = try JSONDecoder().decode(Contact.self, from: data)
          CoreDataManager.shared.saveContext()
          self.isContactSync.value = true
          self.contact.value = contact
        } catch {
          self.error.value = ErrorExtension(error.localizedDescription)
          print("Unable to decode contact. error: \(error)")
        }
      case .failure(let error):
        self.error.value = ErrorExtension(error.localizedDescription)
        print("Error in contact sync. error: \(error)")
      }
    }
  }
  
  private func validateContact() -> Bool {
    guard let firstName = contact.value.firstName else {
      error.value = ErrorExtension(NSLocalizedString("Please enter first name.", comment: ""))
      return false
    }
    
    if firstName.count < 2 {
      let message = NSLocalizedString("First name is too short (minimum is 2 characters)", comment: "")
      error.value = ErrorExtension(message)
      return false
    }
    
    guard let lastName = contact.value.lastName else {
      error.value = ErrorExtension(NSLocalizedString("Please enter last name.", comment: ""))
      return false
    }
    
    if lastName.count < 2 {
      let message = NSLocalizedString("Last name is too short (minimum is 2 characters)", comment: "")
      error.value = ErrorExtension(message)
      return false
    }
    
    if let mobile = contact.value.phoneNumber, mobile.count < 10 {
      let message = NSLocalizedString("Please enter a vailid mobile number. Mobile number should be of 10 digits or more.", comment: "")
      error.value = ErrorExtension(message)
      return false
    }
    
    if let email = contact.value.email {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      if !emailPredicate.evaluate(with: email) {
        error.value = ErrorExtension(NSLocalizedString("Please enter a valid email.", comment: ""))
        return false
      }
    }
    return true
  }
}
