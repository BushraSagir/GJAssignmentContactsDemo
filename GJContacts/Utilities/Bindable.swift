//
//  Bindable.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import Foundation
import UIKit

class Bindable<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {
          return
        }
        self.listener?(self.value)
      }
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}

class BindableTextField: UITextField {
  typealias Listener = (String) -> Void
  var textChanged: Listener = { _ in }
  
  func bind(listener: @escaping Listener) {
    self.textChanged = listener
    self.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
  }
  
  @objc func textFieldDidChanged(_ textField: UITextField) {
    self.textChanged(textField.text!)
  }
}
