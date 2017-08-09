//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ContactDetailTableViewCellReuseIdentifier"
    
    var label: UILabel!
    var textField: UITextField!
    
    // Would normally use Snapkit for programmatic UI (http://snapkit.io/)
    private var cnX: NSLayoutConstraint!
    private var cnY: NSLayoutConstraint!
    private var cnWidth: NSLayoutConstraint!
    private var cnHeight: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        // Label
        label = UILabel()
        // label.backgroundColor = UIColor.yellow
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 20)
        cnY = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10)
        cnHeight = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0, constant: 16.0)
        contentView.addConstraints([cnX, cnY, cnHeight])
        
        // Text field
        textField = UITextField()
        // textField.backgroundColor = UIColor.orange
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 17.0)
        contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1, constant: 0)
        cnY = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 10)
        cnWidth = NSLayoutConstraint(item: textField, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -20)
        cnHeight = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraints([cnX, cnY, cnWidth, cnHeight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        
        textField.text = nil
        textField.keyboardType = .default
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
    }

}
