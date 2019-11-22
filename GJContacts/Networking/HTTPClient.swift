//
//  HTTPClient.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation

class HTTPClient {
  // MARK: Typealias
  typealias CompletionResult = (Result<Data?, Error>) -> Void
  
  // MARK: - Shared Instance
  static let shared = HTTPClient(session: URLSession.shared)
  
  // MARK: - Private Properties
  private let session: URLSessionProtocol
  private var task: URLSessionDataTaskProtocol?
  private var completionResult: CompletionResult?
  
  // MARK: - Initialiser
  init(session: URLSessionProtocol) {
    self.session = session
  }
  
  // MARK: - Data Task Helper
  func dataTask(_ request: APIProtocol, completion: @escaping CompletionResult) {
    completionResult = completion
    var urlRequest = URLRequest(url: request.baseURL.appendingPathComponent(request.path),
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                timeoutInterval: Constants.Service.timeout)
    urlRequest.httpMethod = request.httpMethod.rawValue
    urlRequest.httpBody = request.httpBody
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    task = session.dataTask(with: urlRequest) { (data, response, error) in
      //return error if there is any error in making request
      if let error = error {
        print(error.localizedDescription)
        self.completionResult(.failure(ErrorExtension(error.localizedDescription)))
        return
      }
      
      //check response
      if let response = response, response.isSuccess {
        if let data = data {
          self.completionResult(.success(data))
        }
        
        if response.httpStatusCode == 204 {
          self.completionResult(.success(nil))
        }
      } else {
        let commonErrorMessage = NSLocalizedString("Somthing went wrong!", comment: "")
        guard let data = data else {
          print(commonErrorMessage)
          self.completionResult(.failure(ErrorExtension(commonErrorMessage)))
          return
        }
        do {
          let serverError = try JSONDecoder().decode(ServerError.self, from: data)
          print(serverError.error ?? commonErrorMessage)
          self.completionResult(.failure(ErrorExtension(serverError.error ?? commonErrorMessage)))
        } catch {
          print("\(commonErrorMessage). Error: \(error)")
          self.completionResult(.failure(ErrorExtension(commonErrorMessage)))
        }
      }
    }
    
    //Resume task
    self.task?.resume()
  }
  
  func cancel() {
    self.task?.cancel()
  }
  
  // MARK: - Private Helper Function
  private func completionResult(_ result: Result<Data?, Error>) {
    DispatchQueue.main.async {
      self.completionResult?(result)
    }
  }
}
