//
//  InternalNotificationView.swift
//  TearBud
//
//  Created by Michael Rose on 12/14/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

protocol InternalNotificationViewDelegate: class {
    func userDidTapInternalNotificationView(notification: InternalNotificationView)
    func internalNotificationViewDidFinish(notification: InternalNotificationView)
}

enum InternalNotificationPriority: Int {
    case low    =  0
    case high   =  1    // Move the notification to the front of the list
}

class InternalNotificationView: UIView {

    weak var delegate: InternalNotificationViewDelegate?
    
    var priority: InternalNotificationPriority = .low
    var dateCreated: Date!
    
    fileprivate var tapGesture: UITapGestureRecognizer!
    var closeButton: UIButton!
    
    var cnX: NSLayoutConstraint!
    var cnY: NSLayoutConstraint!
    var cnWidth: NSLayoutConstraint!
    var cnHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Used by notification manager in addition to priority sorting.
        // Notifications are sorted by priority, then by date created (first in, first out).
        dateCreated = Date()
        
        // Tap Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTap))
        addGestureRecognizer(tapGesture)
        
        // Close Button
        closeButton = UIButton(type: .custom)
        let image = UIImage(named: "closeIconTiny")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = UIColor.RGB(r: 155, g: 155, b: 155)
        closeButton.addTarget(self, action: #selector(userDidClose), for: .touchUpInside)
        addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        cnX = NSLayoutConstraint.init(item: closeButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10.0)
        cnY = NSLayoutConstraint.init(item: closeButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        cnWidth = NSLayoutConstraint.init(item: closeButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30.0)
        cnHeight = NSLayoutConstraint.init(item: closeButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30.0)
        addConstraints([cnX, cnY, cnWidth, cnHeight])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func prepareForDisplay() {
        //
    }
    
    func removeFromManager() {
        delegate?.internalNotificationViewDidFinish(notification: self)
    }
    
    // MARK: - Private
    
    @objc fileprivate func userDidTap() {
        delegate?.userDidTapInternalNotificationView(notification: self)
    }
    
    @objc fileprivate func userDidClose() {
        removeFromManager()
    }
    
    internal func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textColor = UIColor.RGB(r: 155, g: 155, b: 155)
        label.numberOfLines = 1
        
        return label
    }
    
}
