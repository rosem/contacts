//
//  EditCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {

    static let reuseIdentifier = "EditCellReuseIdentifier"
    
    var detailLabel: UILabel!
    var textField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        // Detail label
        detailLabel = UILabel()
        // detailLabel.backgroundColor = UIColor.yellow
        detailLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        detailLabel.textColor = UIColor.lightGray
        detailLabel.numberOfLines = 1
        contentView.addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20.0)
            make.top.equalToSuperview().offset(10.0)
            make.height.equalTo(16.0)
        }
        
        // Text field
        textField = UITextField()
        // textField.backgroundColor = UIColor.yellow
        textField.font = UIFont.systemFont(ofSize: 17.0)
        textField.autocorrectionType = .no
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(detailLabel.snp.left)
            make.top.equalTo(detailLabel.snp.bottom).offset(3.5)
            make.right.equalToSuperview().offset(-20.0)
            make.bottom.equalToSuperview().offset(-7.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailLabel.text = nil
        
        textField.text = nil
        textField.delegate = nil
        textField.keyboardType = .default
        textField.isEnabled = true
        textField.inputView = nil
        
        selectionStyle = .none
        accessoryType = .none
    }


}
