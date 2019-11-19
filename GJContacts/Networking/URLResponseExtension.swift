//
//  URLResponseExtension.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

extension URLResponse {
  var isSuccess: Bool {
    return httpStatusCode >= 200 && httpStatusCode < 300
  }
  
  var httpStatusCode: Int {
    guard let statusCode = (self as? HTTPURLResponse)?.statusCode else {
      return 0
    }
    return statusCode
  }
}
