//
//  ContactEditViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

class ContactEditViewController: UITableViewController {

    var contact: Contact!
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Initialize
    
    required init(contact: Contact, managedObjectContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.contact = contact
        self.managedObjectContext = managedObjectContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibNameOrNil:, nibBundleOrNil:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Contact"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didFinish))
        cancelButton.tag = 0
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didFinish))
        saveButton.tag = 1
        navigationItem.rightBarButtonItem = saveButton
        
        // View
        view.backgroundColor = UIColor.white
        
        // Table view
        tableView.register(EditCell.self, forCellReuseIdentifier: EditCell.reuseIdentifier)
        
        print("inset = \(tableView.separatorInset)")
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //
    }
    
    // MARK: - Private
    
    func didFinish(button: UIBarButtonItem) {
        let save = button.tag == 1
        if (save) {
            // Validate contact information
            // First, last name each have one character
            
        } else {
            dismiss(animated: true, completion: nil)
        }
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.reuseIdentifier, for: indexPath) as! EditCell
        
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = "First Name"
            cell.textField.text = contact.firstName
            cell.textField.returnKeyType = .done
            break
        case 1:
            cell.detailLabel.text = "Last Name"
            cell.textField.text = contact.lastName
            cell.textField.returnKeyType = .done
            break
        case 2:
            cell.detailLabel.text = "Date of Birth"
            cell.textField.text = contact.dateOfBirthString
            cell.textField.isEnabled = false
            break
        case 3:
            cell.detailLabel.text = "Phone Number"
            cell.textField.text = contact.phoneNumberOnly
            cell.textField.keyboardType = .numberPad
            cell.textField.returnKeyType = .done
            break
        case 4:
            cell.detailLabel.text = "Zip Code"
            cell.textField.text = contact.zipCode
            cell.textField.keyboardType = .numberPad
            cell.textField.returnKeyType = .done
            break
        default: break
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditCell
        if indexPath.row == 2 {
            // DOB
            view.endEditing(true)
        } else {
            cell.textField.becomeFirstResponder()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension ContactEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        switch textField.tag {
        case 0:
            //
            break
        case 1:
            //
            break
        case 2:
            //
            break
        case 3:
            if resultString.characters.count > 10 { return false }
            break
        case 4:
            if resultString.characters.count > 5 { return false }
            break
        default: break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}
