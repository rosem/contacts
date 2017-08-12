//
//  ContactsData.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class ContactsData {

    public static let ContactsDataDidFinishRemoteSeeding = NSNotification.Name(rawValue: "ContactsDataDidFinishRemoteSeeding")
    let SeedContactsDataKey = "SeedContactsDataKey"
    
    static let shared = ContactsData()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Contacts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveMainContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failure to save main context: \(error)")
            }
        }
    }
    
    @objc private func contextDidSave(notification: Notification) {
        if let context = notification.object as? NSManagedObjectContext {
            if context != mainContext {
                mainContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
    
    func seedContactsData() {
        let seeded = UserDefaults.standard.bool(forKey: SeedContactsDataKey)
        if !seeded {
       
            let contacts = [
                (firstName: "Michael", lastName: "Rose", dateOfBirth: "11/11/1983", phoneNumber: "(906) 440-8131", zipCode: "49688")
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            for contact in contacts {
                let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: mainContext) as! Contact
                newContact.firstName = contact.firstName
                newContact.lastName = contact.lastName
                newContact.dateOfBirth = dateFormatter.date(from: contact.dateOfBirth)! as NSDate
                newContact.phoneNumber = contact.phoneNumber
                newContact.zipCode = contact.zipCode
            }
            
            saveMainContext()
            
            UserDefaults.standard.set(true, forKey: SeedContactsDataKey)
        }
    }
    
    func seedRemoteContactsData() {
        let url = URL(string: "http://rosem.com/work/random/contacts-seed.json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                let notification = InternalMessageNotificationView(message: "Merge failed. No data received.")
                notification.label.textColor = UIColor.RGB(r: 238, g: 72, b: 94)
                notification.priority = .high
                InternalNotificationManager.shared.queue(notification: notification)
                
                NotificationCenter.default.post(name: ContactsData.ContactsDataDidFinishRemoteSeeding, object: self, userInfo: nil)
                
                return
            }
            let json = JSON(data: data)
            
            self.persistentContainer.performBackgroundTask({ (context) in
                
                // Get all current UUIDs from the server
                var count = 0
                let request: NSFetchRequest<Contact> = Contact.fetchRequest()
                do {
                    let contacts = try context.fetch(request)
                    // Merge all incoming contacts, but don't allow duplicates
                    for contactJSON in json {
                        let uuidServer = contactJSON.1["id"].stringValue
                        if !contacts.contains(where: { $0.uuidServer == uuidServer }) {
                            let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
                            newContact.firstName = contactJSON.1["name"]["first"].stringValue
                            newContact.lastName = contactJSON.1["name"]["last"].stringValue
                            newContact.dateOfBirth = Date(timeIntervalSince1970: TimeInterval(contactJSON.1["dob"].intValue)) as NSDate
                            newContact.phoneNumber = contactJSON.1["phone"].stringValue
                            newContact.zipCode = contactJSON.1["zip"].stringValue
                            newContact.uuidServer = uuidServer
                            
                            count = count + 1
                        }
                    }
                    
                    // Save to the background context
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            fatalError("Failure to save background context: \(error)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        // Notifify user of contacts merged
                        let countString = count == 1000 ? "1,000" : String(count)
                        let text = count == 1 ? "contact" : "contacts"
                        let message = "\(countString) \(text) merged."
                        
                        let notification = InternalMessageNotificationView(message: message)
                        InternalNotificationManager.shared.queue(notification: notification)
                        
                        NotificationCenter.default.post(name: ContactsData.ContactsDataDidFinishRemoteSeeding, object: self, userInfo: nil)
                    }
                    
                } catch {
                    fatalError("Failed to fetch contacts: \(error)")
                }
            })
        }).resume()
    }
}
