//
//  APIProtocol.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

protocol APIProtocol {
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var httpBody: Data? { get }
  var headers: HTTPHeaders? { get }
}
