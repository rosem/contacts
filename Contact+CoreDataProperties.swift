//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String!
    @NSManaged public var lastName: String!
    @NSManaged public var dateOfBirth: String!
    @NSManaged public var phoneNumber: String!
    @NSManaged public var zipCode: String!
    
    public var displayName: String {
        return lastName + ", " + firstName
    }

}
