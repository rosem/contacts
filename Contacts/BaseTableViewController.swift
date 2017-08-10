//
//  BaseTableViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/10/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Configuration
    
    func configureCell(_ cell: ContactTableViewCell, forContact contact: Contact) {
        cell.label.text = contact.displayName
    }
    
}
