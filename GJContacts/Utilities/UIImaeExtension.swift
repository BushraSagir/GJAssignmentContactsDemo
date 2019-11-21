//
//  UIImaeExtension.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/21/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
extension UIImage {
  struct Action {
    static let call = #imageLiteral(resourceName: "CallButton")
    static let mail = #imageLiteral(resourceName: "EmailButton")
    static let message = #imageLiteral(resourceName: "MessageButton")
    static let favorite = #imageLiteral(resourceName: "FavouriteButton")
    static let favouriteSelected = #imageLiteral(resourceName: "FavouriteButtonSelected")
    static let takePhoto = #imageLiteral(resourceName: "CameraButton")
  }

  struct Contact {
    static let placeHolder = #imageLiteral(resourceName: "PlaceholderPhoto")
    static let showFavourite = #imageLiteral(resourceName: "HomeFavourite")
  }
}
