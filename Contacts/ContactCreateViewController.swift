//
//  ContactCreateViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import CoreData

protocol ContactCreateViewControllerDelegate: class {
    func contactCreateViewControllerDidFinish(viewController: ContactCreateViewController, save: Bool)
}

class ContactCreateViewController: UITableViewController {

    weak var delegate: ContactCreateViewControllerDelegate?
    
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

        title = "Create Contact"
        
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
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //
    }
    
    // MARK: - Private
    
    func didFinish(button: UIBarButtonItem) {
        let save = button.tag == 1
        if (save) {
            if contact.firstName == nil || contact.lastName == nil {
                // INVALID
                let alertController = UIAlertController(title: "Invalid Contact", message: "A valid first and last name is required.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
                
                return
            }
            if let first = contact.firstName {
                let stripFirst = removeWhitespace(string: first)
                if stripFirst.characters.count < 1 {
                    // INVALID
                    let alertController = UIAlertController(title: "Invalid Contact", message: "A valid first and last name is required.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                    return
                }
            }
            
            if let last = contact.lastName {
                let stripLast = removeWhitespace(string: last)
                if stripLast.characters.count < 1 {
                    // INVALID
                    let alertController = UIAlertController(title: "Invalid Contact", message: "A valid first and last name is required.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                    return
                }
            }
            
            if let number = contact.phoneNumber {
                if number.characters.count < 10 && number.characters.count > 0 {
                    // INVALID
                    let alertController = UIAlertController(title: "Invalid Contact", message: "A valid 10-digit phone number is required.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                    return
                }
            }
            
            if let zip = contact.zipCode {
                if zip.characters.count < 5 && zip.characters.count > 0 {
                    // INVALID
                    let alertController = UIAlertController(title: "Invalid Contact", message: "A valid 5-digit zip code is required.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                    return
                }
            }
        
            // VALID
            delegate?.contactCreateViewControllerDidFinish(viewController: self, save: save)
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func removeWhitespace(string: String) -> String {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        return string.trimmingCharacters(in: whitespaceCharacterSet)
    }
    
    func dateValueDidChange(datePicker: UIDatePicker) {
        contact.dateOfBirth = datePicker.date as NSDate
        
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! EditCell
        cell.textField.text = contact.dateOfBirthString
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
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(dateValueDidChange), for: .valueChanged)
            cell.textField.inputView = datePicker
            
            if let date = contact.dateOfBirth {
                datePicker.setDate(date as Date, animated: false)
            }
            
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
        cell.textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension ContactCreateViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        switch textField.tag {
        case 0:
            // First name
            if resultString.characters.count > 0 {
                contact.firstName = resultString
            } else {
                contact.firstName = nil
            }
            break
        case 1:
            // Last name
            if resultString.characters.count > 0 {
                contact.lastName = resultString
            } else {
                contact.lastName = nil
            }
            break
        case 2:
            // Date of birth
            break
        case 3:
            if resultString.characters.count > 10 { return false }
            if resultString.characters.count > 0 {
                contact.phoneNumber = resultString
            } else {
                contact.phoneNumber = nil
            }
            break
        case 4:
            if resultString.characters.count > 5 { return false }
            if resultString.characters.count > 0 {
                contact.zipCode = resultString
            } else {
                contact.zipCode = nil
            }
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
