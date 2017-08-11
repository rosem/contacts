//
//  InternalSyncNotificationView.swift
//  TearBud
//
//  Created by Michael Rose on 12/15/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

class InternalSyncNotificationView: InternalNotificationView {
    
    var progressView: UIProgressView!
    
    fileprivate var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Sync notifications should always have a high priority
        priority = .high
        
        // Label
        label = createLabel()
        label.text = "Downloading"
        label.sizeToFit()
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10.0)
        cnY = NSLayoutConstraint.init(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraints([cnX, cnY])
        
        // Progress View
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.5
        addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint.init(item: progressView, attribute: .left, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1.0, constant: 10.0)
        cnY = NSLayoutConstraint.init(item: progressView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        cnWidth = NSLayoutConstraint.init(item: progressView, attribute: .right, relatedBy: .equal, toItem: closeButton, attribute: .left, multiplier: 1.0, constant: -7.0)
        addConstraints([cnX, cnY, cnWidth])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



