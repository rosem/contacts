//
//  ContactsData.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import Foundation
import CoreData

class ContactsData {
    
    let SeedContactsDataKey = "SeedContactsDataKey"
    
    static let shared = ContactsData()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Contacts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func seedContactsData() {
        let seeded = UserDefaults.standard.bool(forKey: SeedContactsDataKey)
        if !seeded {
       
            let contacts = [
                (firstName: "Michael", lastName: "Rose", dateOfBirth: "11-11-1983", phoneNumber: "(906) 440-8131", zipCode: "49688"),
                (firstName: "Emma", lastName: "Rose", dateOfBirth: "8-25-2016", phoneNumber: "(231) 555-5555", zipCode: "49688"),
                (firstName: "Jessica", lastName: "Hubl", dateOfBirth: "2-18-1982", phoneNumber: "(402) 203-7657", zipCode: "49688")
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d-m-yyyy"
            
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
}
