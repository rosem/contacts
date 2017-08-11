//
//  ReadButtonCell.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit

class ReadButtonCell: ReadCell {

    static let reuseButtonIdentifier = "ReadButtonCellReuseIdentifier"
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Main label
        mainLabel.textColor = UIColor.RGB(r: 21, g: 126, b: 251)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainLabel.textColor = UIColor.RGB(r: 21, g: 126, b: 251)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let textColor = highlighted ? UIColor.RGB(r: 201, g: 224, b: 249) : UIColor.RGB(r: 21, g: 126, b: 251)
        mainLabel.textColor = textColor
    }
}
