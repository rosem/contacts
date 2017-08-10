//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailViewController: UITableViewController {

    var contact: Contact!
    
    // MARK: - Initialize
    
    required init(contact: Contact) {
        super.init(nibName: nil, bundle: nil)
        
        self.contact = contact
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibNameOrNil:, nibBundleOrNil:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contact"
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didEdit))
        navigationItem.rightBarButtonItem = editButton
        
        // View
        view.backgroundColor = UIColor.white
        
        // Table view
        tableView.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: ContactDetailTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //
    }
    
    // MARK: - Private
    
    @objc private func didEdit() {
        //
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.reuseIdentifier, for: indexPath) as! ContactDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = "First Name"
            cell.mainLabel.text = contact.firstName
            break
        case 1:
            cell.detailLabel.text = "Last Name"
            cell.mainLabel.text = contact.lastName
            break
        case 2:
            cell.detailLabel.text = "Age"
            cell.mainLabel.text = String(contact.age)
            break
        case 3:
            cell.detailLabel.text = "Date of Birth"
            cell.mainLabel.text = contact.dateOfBirthString
            break
        case 4:
            cell.detailLabel.text = "Phone"
            cell.mainLabel.text = contact.phoneNumber
            cell.accessoryType = .disclosureIndicator
            break
        case 5:
            cell.detailLabel.text = "ZIP"
            cell.mainLabel.text = contact.zipCode
            cell.accessoryType = .disclosureIndicator
            break
        default: break
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }

}
