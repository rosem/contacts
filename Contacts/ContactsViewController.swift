//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: BaseTableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Contact> = {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let lastNameSort = NSSortDescriptor(key: "lastName", ascending: true)
        let firstNameSort = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [lastNameSort, firstNameSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ContactsData.shared.mainContext, sectionNameKeyPath: "sectionLetter", cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var network: NetworkReachability!
    
    var searchController: UISearchController!
    var searchResultsViewController: SearchResultsViewController!
    
    var actionItem: UIBarButtonItem {
        let actionItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didAction))
        actionItem.tag = 1
        
        return actionItem
    }
    var activityItem: UIBarButtonItem {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.startAnimating()
        let activityItem = UIBarButtonItem(customView: activityView)
        activityItem.tag = 2
        
        return activityItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Network reachability
        network = NetworkReachability()
        do {
            try network.startNotifier()
        } catch {
            print("Error starting network notifier")
        }
        
        title = "Contacts"
        navigationItem.leftBarButtonItem = actionItem
        navigationItem.leftBarButtonItem?.isEnabled = network.isReachable
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didCreate))
        
        network.whenReachable = { reachability in
            if let item = self.navigationItem.leftBarButtonItem {
                if item.tag == 1 {
                    item.isEnabled = true
                }
            }
        }
        
        network.whenUnreachable = { reachability in
            if let item = self.navigationItem.leftBarButtonItem {
                if item.tag == 1 {
                    item.isEnabled = false
                }
            }
        }
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(didFinish), name: ContactsData.ContactsDataDidFinishRemoteSeeding, object: nil)
        
        // Search results view controller
        searchResultsViewController = SearchResultsViewController(style: .plain)
        searchResultsViewController.tableView.delegate = self
        
        // Search controller
        searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        // NSFetchedResultsController<Contacts>
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //
    }
    
    // MARK: - Private
    
    @objc private func didFinish() {
        let item = self.actionItem
        item.isEnabled = network.isReachable
        self.navigationItem.setLeftBarButton(item, animated: true)
    }
    
    @objc private func didAction() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let download = UIAlertAction(title: "Download/Merge 1,000 Contacts", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.network.isReachable {
                self.navigationItem.setLeftBarButton(self.activityItem, animated: true)
                ContactsData.shared.seedRemoteContactsData()
            } else {
                let notification = InternalMessageNotificationView(message: "Merge failed. No internet connection.")
                notification.label.textColor = UIColor.RGB(r: 238, g: 72, b: 94)
                notification.priority = .high
                InternalNotificationManager.shared.queue(notification: notification)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(download)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func didCreate() {
        /*
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = ContactsData.shared.mainContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: childContext) as! Contact
        
        let viewController = ContactEditViewController(contact: contact, managedObjectContext: childContext)
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
        */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sectionIndexTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier, for: indexPath) as! ContactTableViewCell
        
        let contact = fetchedResultsController.object(at: indexPath)
        configureCell(cell, forContact: contact)
        
        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact: Contact
        
        if tableView == self.tableView {
            contact = fetchedResultsController.object(at: indexPath)
        } else {
            contact = searchResultsViewController.filteredContacts[indexPath.row]
        }
        
        let viewController = ContactDetailViewController(contact: contact)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension ContactsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = fetchedResultsController.fetchedObjects!
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        // Each "search item" needs to match the FIRST or LAST name to qualify
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            var searchItemsPredicate = [NSPredicate]()
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let firstNameExpression = NSExpression(forKeyPath: "firstName")
            let firstNameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: firstNameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            searchItemsPredicate.append(firstNameSearchComparisonPredicate)
            
            let lastNameExpression = NSExpression(forKeyPath: "lastName")
            let lastNameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: lastNameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            searchItemsPredicate.append(lastNameSearchComparisonPredicate)
            
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:searchItemsPredicate)
            return orMatchPredicate
        }
        
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        searchResultsViewController.filteredContacts = filteredResults
        searchResultsViewController.tableView.reloadData()
    }
    
}

extension ContactsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

