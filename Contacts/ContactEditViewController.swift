//
//  ContactEditViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/12/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class ContactEditViewController: ContactCreateViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Contact"
        
        // Table view
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 61.0)
        
        let div = UIView()
        div.backgroundColor = tableView.separatorColor
        div.frame = CGRect(x: 16.0, y: -0.5, width: tableView.bounds.size.width-16.0, height: 0.5)
        footerView.addSubview(div)
        
        let deleteButton = UIButton(type: .roundedRect)
        deleteButton.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60.0)
        deleteButton.setTitleColor(UIColor.red, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        deleteButton.setTitle("Delete Contact", for: .normal)
        deleteButton.addTarget(self, action: #selector(didDelete), for: .touchUpInside)
        footerView.addSubview(deleteButton)
        
        tableView.tableFooterView = footerView
    }
    
    func didDelete() {
        let alertController = UIAlertController(title: "Delete Contact", message: "This will remove the contact from the device.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let nav = self.presentingViewController as! UINavigationController
            nav.popToRootViewController(animated: false)
            self.dismiss(animated: true, completion: {
                let mainContext = ContactsData.shared.mainContext
                let deleteContact = mainContext.object(with: self.contact.objectID)
                mainContext.delete(deleteContact)
                ContactsData.shared.saveMainContext()
            })
        }
        alertController.addAction(cancel)
        alertController.addAction(delete)
        present(alertController, animated: true, completion: nil)
        
    }
    
}
