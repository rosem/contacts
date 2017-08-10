//
//  SearchResultsViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/10/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsViewController: BaseTableViewController {

    var filteredContacts = [Contact]()
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as! ContactTableViewCell
        
        let contact = filteredContacts[indexPath.row]
        configureCell(cell, forContact: contact)
        
        return cell
    }

}
