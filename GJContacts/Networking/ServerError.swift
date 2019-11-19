//
//  ServerError.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

struct ServerError: Decodable {
  let status: String?
  let error: String?
}
