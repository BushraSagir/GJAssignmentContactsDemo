//
//  UIViewExtension.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIView {
  func showLoader(show: Bool) {
    if show {
      MBProgressHUD.showAdded(to: self, animated: true)
    } else {
      MBProgressHUD.hide(for: self, animated: true)
    }
  }
}
