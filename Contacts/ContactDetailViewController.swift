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
        tableView.register(ReadCell.self, forCellReuseIdentifier: ReadCell.reuseIdentifier)
        tableView.register(ReadButtonCell.self, forCellReuseIdentifier: ReadButtonCell.reuseButtonIdentifier)
        tableView.register(ReadDoubleCell.self, forCellReuseIdentifier: ReadDoubleCell.reuseIdentifier)
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
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if indexPath.row == 2 {
            // Double
            let double = tableView.dequeueReusableCell(withIdentifier: ReadDoubleCell.reuseIdentifier, for: indexPath) as! ReadDoubleCell
            double.detailLeftLabel.text = "Date of Birth"
            double.mainLeftLabel.text = contact.dateOfBirthString
            double.detailRightLabel.text = "Age"
            double.mainRightLabel.text = String(contact.age)
            
            cell = double
        } else if indexPath.row == 3 || indexPath.row == 4 {
            let button = tableView.dequeueReusableCell(withIdentifier: ReadButtonCell.reuseButtonIdentifier, for: indexPath) as! ReadButtonCell
            
            switch indexPath.row {
            case 3:
                button.detailLabel.text = "Phone Number"
                button.mainLabel.text = contact.phoneNumber
                break
            case 4:
                button.detailLabel.text = "Zip Code"
                button.mainLabel.text = contact.zipCode
                break
            default: break
            }
            
            cell = button
        } else {
            // Single
            let single = tableView.dequeueReusableCell(withIdentifier: ReadCell.reuseIdentifier, for: indexPath) as! ReadCell
            
            switch indexPath.row {
            case 0:
                single.detailLabel.text = "First Name"
                single.mainLabel.text = contact.firstName
                break
            case 1:
                single.detailLabel.text = "Last Name"
                single.mainLabel.text = contact.lastName
                break
            default: break
            }
            
            cell = single
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            // Phone
            let phoneNumber = contact.phoneNumberOnly
            if let phoneCallURL:URL = URL(string: "tel:\(phoneNumber)") {
                let application: UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    let alertController = UIAlertController(title: "Call Contact", message: "Are you sure you want to call \n\(contact.phoneNumber!)?", preferredStyle: .alert)
                    let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    })
                    let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                        
                    })
                    alertController.addAction(yesPressed)
                    alertController.addAction(noPressed)
                    present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Call Contact", message: "This device does not support phone calls.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                    })
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                }
            }
            
        } else if indexPath.row == 4 {
            // Map
            let mapViewController = MapViewController(zipCode: contact.zipCode)
            let navController = UINavigationController(rootViewController: mapViewController)
            
            present(navController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}
