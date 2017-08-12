//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ContactTableViewCellReuseIdentifier"

    var label: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Label
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20.0)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }

}
