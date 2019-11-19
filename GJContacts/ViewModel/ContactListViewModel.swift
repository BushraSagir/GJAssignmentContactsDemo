//
//  ContactListViewModel.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

class ContactListViewModel {
  
  private var httpClient: HTTPClient?
  
  var isBusy: Bindable<Bool> = Bindable(false)
  var contacts: Bindable<[Contact]?> = Bindable(nil)
  var error: Bindable<ErrorExtension?> = Bindable(nil)
  
  init(client: HTTPClient? = nil) {
    self.httpClient = client ?? HTTPClient.shared
  }
  
  func getContacts() {
    isBusy.value = true
    httpClient?.dataTask(ContactWebService.getContacts) { [weak self] (result) in
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
          Contact.deleteAllContacts()
          let contacts = try JSONDecoder().decode([Contact].self, from: data)
          CoreDataManager.shared.saveContext()
          self.contacts.value = contacts
          print("Contact sync successfully.")
        } catch {
          print("Unable to decode Contact List. Error: \(error)")
        }
      case .failure(let error):
        self.error.value = ErrorExtension(error.localizedDescription)
        print("Error in fetching Contacts. Error: \(error)")
      }
    }
  }
}

