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
    @NSManaged public var dateOfBirth: NSDate!
    @NSManaged public var phoneNumber: String!
    @NSManaged public var zipCode: String!
    
    public var displayName: String {
        return lastName + ", " + firstName
    }
    
    public var sectionLetter: String {
        let letter = lastName[lastName.startIndex]
        return String(letter)
    }
    
    public var dateOfBirthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self.dateOfBirth as Date)
    }
    
    public var age: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth as Date, to: now)
        
        return ageComponents.year!
    }
    
    public var phoneNumberOnly: String {
        // TODO: Better parsing of phone number
        var number = phoneNumber!
        number = number.replacingOccurrences(of: "(", with: "")
        number = number.replacingOccurrences(of: ")", with: "")
        number = number.replacingOccurrences(of: "-", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        
        return number
    }

}
