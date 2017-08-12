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

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var zipCode: String?
    
    public var displayName: String? {
        if firstName != nil && lastName != nil {
            return lastName! + ", " + firstName!
        }
        
        return nil
    }
    
    public var sectionLetter: String? {
        if let name = lastName {
            let letter = name[name.startIndex]
            let letterString = String(letter)
            
            let digits = CharacterSet.decimalDigits
            for uni in letterString.unicodeScalars {
                if digits.contains(uni) {
                    return "#"
                }
            }
            
            return letterString
        }
        
        return nil
    }
    
    public var dateOfBirthString: String? {
        if let dob = dateOfBirth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: dob as Date)
        }
        
        return nil
    }
    
    public var age: Int? {
        if let dob = dateOfBirth {
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dob as Date, to: now)
            
            return ageComponents.year!
        }
        
        return nil
    }
    
    public var phoneNumberOnly: String? {
        // TODO: Better parsing of phone number
        if var number = phoneNumber {
            number = number.replacingOccurrences(of: "(", with: "")
            number = number.replacingOccurrences(of: ")", with: "")
            number = number.replacingOccurrences(of: "-", with: "")
            number = number.replacingOccurrences(of: " ", with: "")
            
            return number
        }
        
        return nil
    }

}
