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
    
    var detailLabel: UILabel!
    var mainLabel: UILabel!
    
    // Would normally use Snapkit for programmatic UI (http://snapkit.io/)
    private var cnX: NSLayoutConstraint!
    private var cnY: NSLayoutConstraint!
    private var cnWidth: NSLayoutConstraint!
    private var cnHeight: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        // Label
        detailLabel = UILabel()
        // detailLabel.backgroundColor = UIColor.yellow
        detailLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        detailLabel.textColor = UIColor.lightGray
        detailLabel.numberOfLines = 1
        contentView.addSubview(detailLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint(item: detailLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 20)
        cnY = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10)
        cnHeight = NSLayoutConstraint(item: detailLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0, constant: 16.0)
        contentView.addConstraints([cnX, cnY, cnHeight])
        
        // Text field
        mainLabel = UILabel()
        // mainLabel.backgroundColor = UIColor.yellow
        mainLabel.font = UIFont.systemFont(ofSize: 17.0)
        mainLabel.numberOfLines = 1
        contentView.addSubview(mainLabel)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint(item: mainLabel, attribute: .left, relatedBy: .equal, toItem: detailLabel, attribute: .left, multiplier: 1, constant: 0)
        cnY = NSLayoutConstraint(item: mainLabel, attribute: .top, relatedBy: .equal, toItem: detailLabel, attribute: .bottom, multiplier: 1, constant: 10)
        cnWidth = NSLayoutConstraint(item: mainLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -20)
        cnHeight = NSLayoutConstraint(item: mainLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -10)
        contentView.addConstraints([cnX, cnY, cnWidth, cnHeight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailLabel.text = nil
        mainLabel.text = nil
        
        accessoryType = .none
    }

}
