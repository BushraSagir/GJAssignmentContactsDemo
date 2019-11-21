//
//  ContactListViewController.swift
//  GJContacts
//
//  Created by Bushra Sagir on 11/19/19.
//  Copyright © 2019 bushraSagir. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController {
  @IBOutlet weak var contactTableView: UITableView!

  private let viewModel = ContactListViewModel()
  var fetchedResultController: NSFetchedResultsController<Contact>?

    override func viewDidLoad() {
      super.viewDidLoad()
      contactTableView.delegate = self
      contactTableView.dataSource = self
      setupFetchedResultController()
      setupBindingAndGetContacts()
        // Do any additional setup after loading the view.
    }
    
  private func setupFetchedResultController() {
    let contactsFetchRequest: NSFetchRequest<Contact> = Contact.fetchContactRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Contact.firstName),
                                          ascending: true,
                                          selector: #selector(NSString.caseInsensitiveCompare(_:)))
    contactsFetchRequest.sortDescriptors = [sortDescriptor]
    let managedObjectContext = CoreDataManager.shared.managedObjectContext
    fetchedResultController = .init(fetchRequest: contactsFetchRequest,
                                    managedObjectContext: managedObjectContext,
                                    sectionNameKeyPath: #keyPath(Contact.sectionTitle),
                                    cacheName: nil)
    fetchedResultController?.delegate = self
  }

  private func setupBindingAndGetContacts() {
    //Binding
    viewModel.isBusy.bind { [unowned self] isBusy in
      self.view.showLoader(show: isBusy)
    }
    
    viewModel.contacts.bind { [unowned self] (contacts) in
      if contacts != nil {
        self.performFetchRequest()
      }
    }
    
    viewModel.error.bind { [unowned self] (error) in
      if let error = error {
        self.performFetchRequest()
        let alert = UIAlertController(
          title: nil,
          message: error.localizedDescription,
          preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
    viewModel.getContacts()
  }

  @IBAction func addNewContactPressed(_ sender: UIBarButtonItem) {
    AddContactViewController.present(contact: nil)
  }
  
  private func performFetchRequest() {
    do {
      try fetchedResultController?.performFetch()
      contactTableView.reloadData()
    } catch {
      print("Unable to perform fetch operation from DB. Error: \(error)")
    }
  }
}

extension ContactListViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    contactTableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      contactTableView.insertRows(at: [newIndexPath!], with: .none)
    case .delete:
      contactTableView.deleteRows(at: [indexPath!], with: .none)
    case .update:
      contactTableView.reloadRows(at: [indexPath!], with: .none)
    case .move:
      contactTableView.moveRow(at: indexPath!, to: newIndexPath!)
    default:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      contactTableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
    case .delete:
      contactTableView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
    case .update:
      contactTableView.reloadSections(IndexSet(integer: sectionIndex), with: .none)
    default:
      break
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    contactTableView.endUpdates()
  }
  
}

// MARK: - UITableView Data Source
extension ContactListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultController?.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultController?.sections?[section].objects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell",
                                                   for: indexPath) as? ContactListTableViewCell else {
                                                    fatalError("Unable to dequeue ContactTableViewCell.")
    }
    cell.config(contact: fetchedResultController!.object(at: indexPath))
    cell.accessibilityIdentifier = String(format: "contactTableViewCell_%ld_%ld", indexPath.section, indexPath.row)
    return cell
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return fetchedResultController?.sectionIndexTitles
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return fetchedResultController?.sections?[section].indexTitle
  }
}

extension ContactListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contact = fetchedResultController!.object(at: indexPath)
    let contactDetailsViewController = ContactDetailViewController.get(contact)
    navigationController?.pushViewController(contactDetailsViewController, animated: true)
  }
}
