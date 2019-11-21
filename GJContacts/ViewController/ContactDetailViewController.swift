//
//  ContactDetailViewController.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/20/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var topContainerView: UIView!
  @IBOutlet weak var detailsTableView: UITableView!
  @IBOutlet weak var favoriteImageView: UIImageView!
  
  // MARK: - Private Properties
  private var navigationBarShadowImage: UIImage?
  
  // MARK: - Internal Properties
  var viewModel: ContactDetailsViewModel!
  
  // MARK: - Class Functions
  class func get(_ contact: Contact) -> UIViewController {
    
    if let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
      detailsViewController.viewModel = ContactDetailsViewModel(contact: contact)
      return detailsViewController
    }
    return UIViewController()
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    userImageView.layer.masksToBounds = true
    setupTableView()
    setupBindingAndGetContact()
    setupNavigationBarButtonItems()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = navigationBarShadowImage
  }
  
  // MARK: - Helper Functions
  private func setupNavigationBarButtonItems() {
    //Store original shadow image
    navigationBarShadowImage = navigationController?.navigationBar.shadowImage
    
    //set edit contact bar button item
    let editBarButtonItem = UIBarButtonItem(title: viewModel?.editBarButtonTitle,
                                            style: .plain,
                                            target: self,
                                            action: #selector(editBarButtonItemAction))
    navigationItem.rightBarButtonItem = editBarButtonItem
  }
  
  private func setupTableView() {
    detailsTableView.delegate = self
    detailsTableView.dataSource = self
    detailsTableView.tableFooterView = UIView(frame: CGRect.zero)
  }
  
  private func setupBindingAndGetContact() {
    //Binding
    viewModel.isBusy.bind { [unowned self] isBusy in
      self.navigationController?.view.showLoader(show: isBusy)
    }
    
    viewModel.contact.bind(listener: {[unowned self] (_) in
      let isFavourite = self.viewModel?.isFavourite ?? false
      let image = isFavourite ? UIImage.Action.favouriteSelected : UIImage.Action.favorite
      self.favoriteImageView.image = image
      
      self.userImageView.image = UIImage.Contact.placeHolder
      self.userName.text = self.viewModel?.name
      self.detailsTableView.reloadData()
    })
    
    viewModel.error.bind { [unowned self] (error) in
      if let error = error {
        let alert = UIAlertController(
          title: nil,
          message: error.localizedDescription,
          preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
    
    viewModel.getContactDetails()
  }
  
  // MARK: - Actions
  @objc private func editBarButtonItemAction() {
    AddContactViewController.present(contact: viewModel.contact.value, delegate: self)
  }
  
  @IBAction func messageTapGestureAction(_ sender: UITapGestureRecognizer) {
    guard  let messageURL = viewModel.messageURL else {
      let alert = UIAlertController(
        title: nil,
        message: "Contact number not valid.",
        preferredStyle: .alert
      )
      alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    UIApplication.shared.open(messageURL, options: [:], completionHandler: nil)
  }
  
  @IBAction func callTapGestureAction(_ sender: UITapGestureRecognizer) {
    guard  let telURL = viewModel.telURL else {
      let alert = UIAlertController(
        title: nil,
        message: "Contact number not valid.",
        preferredStyle: .alert
      )
      alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    UIApplication.shared.open(telURL, options: [:], completionHandler: nil)
  }
  
  @IBAction func emailTapGestureAction(_ sender: UITapGestureRecognizer) {
    guard  let mailURL = viewModel.mailURL else {
      let alert = UIAlertController(
        title: nil,
        message: "Contact email not valid.",
        preferredStyle: .alert
      )
      alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
  }
  
  @IBAction func favouriteTapGestureAction(_ sender: UITapGestureRecognizer) {
    if sender.state == .recognized {
      viewModel.updateFavourite()
    }
  }
}

extension ContactDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.contactMetadata.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier,
                                                   for: indexPath) as? ContactDetailTableViewCell else {
                                                    fatalError("Unable to dequeue ContactDetailsTableViewCell cell.")
    }
    cell.config(metaData: viewModel.contactMetadata[indexPath.row])
    cell.accessibilityIdentifier = String(format: "detailsTableViewCell_%ld", indexPath.row)
    return cell
  }
}

extension ContactDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
}

extension ContactDetailViewController: AddContactViewControllerDelegate {
  func contactSyncSuccessfully(contact: Contact) {
    viewModel.contact.value = contact
  }
}
