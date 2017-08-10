//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ContactTableViewCellReuseIdentifier"

    var label: UILabel!
    
    // Would normally use Snapkit for programmatic UI (http://snapkit.io/)
    private var cnX: NSLayoutConstraint!
    private var cnY: NSLayoutConstraint!
    private var cnWidth: NSLayoutConstraint!
    private var cnHeight: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Label
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 20)
        cnY = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        cnWidth = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -20)
        cnHeight = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        contentView.addConstraints([cnX, cnY, cnWidth, cnHeight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }

}
