//
//  UINavigationTest.swift
//  GJContactsUITests
//
//  Created by Bushra Sagir on 11/21/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import XCTest

class UINavigationTest: XCTestCase {
  private var app: XCUIApplication!
  
  override func setUp() {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testContactListNavigation() {
    let contactNavigationBar = app.navigationBars["Contact"]
    XCTAssertTrue(contactNavigationBar.exists, "Contact list navigation bar not exist.")
    
    let groupButton = contactNavigationBar.buttons["Group"]
    XCTAssertTrue(groupButton.exists, "Group button not exists in contact list navigation bar.")
    
    let addButton = contactNavigationBar.buttons["Add"]
    XCTAssertTrue(addButton.exists, "Group button not exists in contact list navigation bar.")
  }
  
  func testAddContactNavigationFromContactList() {
    let contactNavigationBar = app.navigationBars["Contact"]
    let addButton = contactNavigationBar.buttons["Add"]
    addButton.tap()
    
    let addContactNavigationBar = app.navigationBars["GJContacts.AddContactView"]
    XCTAssertTrue(addContactNavigationBar.exists, "Add contact navigation bar not exist.")
  }
}
