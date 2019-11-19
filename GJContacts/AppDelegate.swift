//
//  AppDelegate.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/18/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().tintColor = UIColor.Common.tint

    // Override point for customization after application launch.
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    CoreDataManager.shared.saveContext()
  }

}

