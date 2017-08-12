//
//  ManagedObject+CoreDataProperties.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import Foundation
import CoreData


extension ManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedObject> {
        return NSFetchRequest<ManagedObject>(entityName: "ManagedObject")
    }

    @NSManaged private var uuidValue: String!
    public var uuid: String! {
        return uuidValue
    }
    @NSManaged public var uuidServer: String?
    
    @NSManaged public var dateCreated: NSDate!
    @NSManaged public var dateModified: NSDate!
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // Init with unique UUID. This is set one time only.
        uuidValue = NSUUID().uuidString
        
        // Init with date create and date modified as the same value. This makes it easy to see if an object has been modified after it was created. Date created is set one time only. Date modified is updated everytime the object has changes and is saved to Core Data ('willSave()').
        let now = NSDate()
        dateCreated = now
        dateModified = now
    }
    
    // Having a date mofified property that automatically updates is handy for syncing with the backend.
    public override func willSave() {
        if hasChanges {
            let now = NSDate()
            if let date = dateModified {
                if now.timeIntervalSince(date as Date) > 1.0 { // Prevents infinite loop
                    dateModified = now
                }
            } else {
                dateModified = now
            }
        }
    }

}
