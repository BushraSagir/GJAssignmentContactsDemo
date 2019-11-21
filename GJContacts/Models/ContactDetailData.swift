//
//  ContactDetailData.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/20/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation
import UIKit

enum ContactDataType {
  case firstName, lastName, email, mobile
}

class ContactDetaildata {
  var desc: String!
  var info: String!
  var type: ContactDataType
  var keyboardType: UIKeyboardType
  
  init(desc: String, info: String?, type: ContactDataType, keyboardType: UIKeyboardType = .default) {
    self.desc = desc
    self.info = info
    self.type = type
    self.keyboardType = keyboardType
  }
}
