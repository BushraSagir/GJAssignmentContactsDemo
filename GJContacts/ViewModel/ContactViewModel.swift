//
//  ContactVViewModel.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

class ContactViewModel {
  private let contact: Contact!
  
  let name: String
  let imageURL: URL?
  let isFavourite: Bool
  
  init(contact: Contact) {
    self.contact = contact
    name = contact.fullName
    imageURL = URL(string: contact.profilePic ?? "")
    isFavourite = contact.favorite
  }
}
