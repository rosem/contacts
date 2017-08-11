//
//  ReadDoubleCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class ReadDoubleCell: UITableViewCell {

    static let reuseIdentifier = "ReadDoubleCellReuseIdentifier"
    
    var detailLeftLabel: UILabel!
    var mainLeftLabel: UILabel!
    
    var detailRightLabel: UILabel!
    var mainRightLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        // Detail Left label
        detailLeftLabel = UILabel()
        // detailLeftLabel.backgroundColor = UIColor.yellow
        detailLeftLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        detailLeftLabel.textColor = UIColor.lightGray
        detailLeftLabel.numberOfLines = 1
        contentView.addSubview(detailLeftLabel)
        
        detailLeftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20.0)
            make.top.equalToSuperview().offset(10.0)
            make.height.equalTo(16.0)
        }
        
        // Main Left label
        mainLeftLabel = UILabel()
        // mainLeftLabel.backgroundColor = UIColor.yellow
        mainLeftLabel.font = UIFont.systemFont(ofSize: 17.0)
        mainLeftLabel.numberOfLines = 1
        contentView.addSubview(mainLeftLabel)
        
        mainLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(detailLeftLabel)
            make.top.equalTo(detailLeftLabel.snp.bottom).offset(3.0)
            make.right.equalToSuperview().dividedBy(2.0)
            make.bottom.equalToSuperview().offset(-7.0)
        }
        
        let div = UIView()
        div.backgroundColor = UIColor.RGB(r: 200, g: 199, b: 204)
        contentView.addSubview(div)
        
        div.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.top.equalToSuperview().offset(5.0)
            make.bottom.equalToSuperview().offset(-5.0)
            make.left.equalTo(mainLeftLabel.snp.right)
        }
        
        // Detail Right label
        detailRightLabel = UILabel()
        // detailRightLabel.backgroundColor = UIColor.yellow
        detailRightLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        detailRightLabel.textColor = UIColor.lightGray
        detailRightLabel.numberOfLines = 1
        contentView.addSubview(detailRightLabel)
        
        detailRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mainLeftLabel.snp.right).offset(20.0)
            make.top.height.equalTo(detailLeftLabel)
        }
        
        // Main Right label
        mainRightLabel = UILabel()
        // mainRightLabel.backgroundColor = UIColor.yellow
        mainRightLabel.font = UIFont.systemFont(ofSize: 17.0)
        mainRightLabel.numberOfLines = 1
        contentView.addSubview(mainRightLabel)
        
        mainRightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(detailRightLabel)
            make.top.bottom.equalTo(mainLeftLabel)
            make.right.equalToSuperview().offset(-20.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailLeftLabel.text = nil
        mainLeftLabel.text = nil
        
        detailRightLabel.text = nil
        mainRightLabel.text = nil
        
        selectionStyle = .none
        accessoryType = .none
    }

}
