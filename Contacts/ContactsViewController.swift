//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Contact> = {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let lastNameSort = NSSortDescriptor(key: "lastName", ascending: true)
        let firstNameSort = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [lastNameSort, firstNameSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ContactsData.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didCreate))
        
        // Table view
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.ReuseIdentifier)
        tableView.tableFooterView = UIView()
        
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
    
    @objc private func didCreate() {
        /*
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = CoreData.shared.mainContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: childContext) as! Note
        
        let viewController = NoteEditViewController(note: note, managedObjectContext: childContext)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.ReuseIdentifier, for: indexPath) as! ContactTableViewCell
        let contact = fetchedResultsController.object(at: indexPath)
        
        cell.configure(contact: contact)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = note.managedObjectContext
        let editNote = childContext.object(with: note.objectID) as! Note
        
        let viewController = NoteEditViewController(note: editNote, managedObjectContext: childContext)
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: true, completion: nil)
    }
    */

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
            
            // Can't "reload" and "move" to same cell simultaneously (according to UIKit).
            
            // This is an issue because I'm sorting on date modified and also displaying it within a
            // label in the UITableViewCell. The cell moves to the correct location (top) after editing,
            // but the label text doesn't update.
            
            // To have it look perfect you have to manually crossfade the label text, while the UITableView
            // does the "move" animation.
            
            let cell = tableView.cellForRow(at: indexPath!) as! ContactTableViewCell
            let contact = fetchedResultsController.object(at: newIndexPath!)
            
            cell.configure(contact: contact, animated: true)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

/*

extension ContactsViewController: NoteEditViewControllerDelegate {
    
    func noteEditViewControllerDidFinish(viewController: NoteEditViewController, save: Bool) {
        var task:(() -> Void)? = nil
        if save && viewController.managedObjectContext.hasChanges {
            task = {
                do {
                    try viewController.managedObjectContext.save() // Save changes to parent context
                } catch {
                    let error = error as NSError
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                CoreData.shared.saveContext() // Save changes to persistant store
            }
        }
        
        dismiss(animated: true, completion: task)
    }
    
}

*/
