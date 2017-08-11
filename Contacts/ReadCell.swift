//
//  ReadCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/9/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import SnapKit

class ReadCell: UITableViewCell {

    static let reuseIdentifier = "ReadCellReuseIdentifier"
    
    var detailLabel: UILabel!
    var mainLabel: UILabel!
    
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
        
        // Main label
        mainLabel = UILabel()
        // mainLabel.backgroundColor = UIColor.yellow
        mainLabel.font = UIFont.systemFont(ofSize: 17.0)
        mainLabel.numberOfLines = 1
        contentView.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { (make) in
            make.left.equalTo(detailLabel.snp.left)
            make.top.equalTo(detailLabel.snp.bottom).offset(3.0)
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
        mainLabel.text = nil
        mainLabel.textColor = UIColor.black
        
        selectionStyle = .none
        accessoryType = .none
    }

}
