//
//  URLSessionDataTaskProtocol.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/22/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
  func resume()
  func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
  
}
