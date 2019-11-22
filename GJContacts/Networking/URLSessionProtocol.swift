//
//  URLSessionProtocol.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/22/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    let task = dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    return task as URLSessionDataTaskProtocol 
  }
}
