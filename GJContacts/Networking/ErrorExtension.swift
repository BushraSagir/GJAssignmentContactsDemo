//
//  ErrorExtension.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

class ErrorExtension: Error {
  var localizedDescription: String
  init(_ localizedDescription: String) {
    self.localizedDescription = localizedDescription
  }
}
