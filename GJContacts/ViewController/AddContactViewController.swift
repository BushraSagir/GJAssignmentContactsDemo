//
//  AddViewController.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/21/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit

protocol AddContactViewControllerDelegate: class {
  func contactSyncSuccessfully(contact: Contact)
}

class AddContactViewController: UIViewController {
  
  // MARK: - Outlet
  @IBOutlet weak var contactImageView: UIImageView!
  @IBOutlet weak var selectImageButton: UIButton!
  @IBOutlet weak var contactTableView: UITableView!
  
  // MARK: - Weak Properties and Delgate
  weak var delegate: AddContactViewControllerDelegate?
  
  // MARK: - Internal Properties
  var imagePicker: ImagePicker!
  
  // MARK: - Properties
  var viewModel: AddContactViewModel!
  
  // MARK: - Class Functions
  class func present(contact: Contact?, delegate: AddContactViewControllerDelegate? = nil) {
    if let addContactViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddContactViewController") as? AddContactViewController {
      addContactViewController.delegate = delegate
      addContactViewController.viewModel = AddContactViewModel(contact: contact)
      let navigationController = UINavigationController(rootViewController: addContactViewController)
      UIApplication.shared.keyWindow?.rootViewController?.present(
        navigationController, animated: true, completion: nil)
    }
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    contactImageView.layer.cornerRadius = contactImageView.bounds.height / 2
    contactImageView.layer.masksToBounds = true
    setupTableView()
    setupImagePicker()
    setupBindingAndGetContact()
    setupNavigationBarButtonItems()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Helper Functions
  private func setupNavigationBarButtonItems() {
    navigationController?.navigationBar.shadowImage = UIImage()
    
    //set cancel and done bar button item
    let cancelBarButtonItem = UIBarButtonItem(title: viewModel?.cancelBarButtonTitle,
                                              style: .plain,
                                              target: self,
                                              action: #selector(cancelBarButtonItemAction))
    navigationItem.leftBarButtonItem = cancelBarButtonItem
    
    let doneBarButtonItem = UIBarButtonItem(title: viewModel?.doneBarButtonTitle,
                                            style: .done,
                                            target: self,
                                            action: #selector(doneBarButtonItemAction))
    navigationItem.rightBarButtonItem = doneBarButtonItem
  }
  
  private func setupTableView() {
    contactTableView.delegate = self
    contactTableView.dataSource = self
    contactTableView.tableFooterView = UIView(frame: CGRect.zero)
    contactTableView.accessibilityIdentifier = "addContactTableView"
    contactImageView.image = UIImage.Contact.placeHolder
  }
  
  private func setupImagePicker() {
    imagePicker = ImagePicker(from: self)
    imagePicker.delegate = self
  }
  
  private func setupBindingAndGetContact() {
    //Binding
    viewModel.isBusy.bind { [unowned self] isBusy in
      self.navigationController?.view.showLoader(show: isBusy)
    }
    
    viewModel.isContactSync.bind { [unowned self] (isSync) in
      if isSync {
        self.delegate?.contactSyncSuccessfully(contact: self.viewModel.contact.value)
        self.dismiss(animated: true, completion: nil)
      }
    }
    
    viewModel.contact.bind(listener: {[unowned self] (_) in
      self.contactTableView.reloadData()
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
  }
  
  @objc private func cancelBarButtonItemAction() {
    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func doneBarButtonItemAction() {
    view.endEditing(true)
    viewModel.syncContact()
  }

  @IBAction func editImagePressed(_ sender: UIButton) {
    imagePicker.showImagePickerSources(sender: sender)
  }
  
}

extension AddContactViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.contactMetadata?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactEditTableViewCell.identifier,
                                                   for: indexPath) as? ContactEditTableViewCell else {
                                                    fatalError("Unable to dequeue ContactDetailsTableViewCell cell.")
    }
    cell.delegate = self
    cell.accessibilityIdentifier = String(format: "editTableViewCell_%ld", indexPath.row)
    cell.config(metaData: viewModel!.contactMetadata[indexPath.row])
    return cell
  }
}

extension AddContactViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
}

extension AddContactViewController: ImagePickerDelegate {
  func didFinishPickingImage(_ image: UIImage?) {
    contactImageView.image = image
  }
}

extension AddContactViewController: ContactEditTableViewCellDelegate {
  func textChanged(contactMetaData: ContactDetaildata, text: String) {
    contactMetaData.info = text
    switch contactMetaData.type {
    case .firstName:
      viewModel.contact.value.firstName = text
    case .lastName:
      viewModel.contact.value.lastName = text
    case .email:
      viewModel.contact.value.email = text
    case .mobile:
      viewModel.contact.value.phoneNumber = text
    }
  }
}
