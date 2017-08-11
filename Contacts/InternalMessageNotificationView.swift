//
//  InternalMessageNotificationView.swift
//  TearBud
//
//  Created by Michael Rose on 12/16/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

class InternalMessageNotificationView: InternalNotificationView {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    var displayTime = 3.0
    var timer: Timer?
    
    convenience init(message: String, image: UIImage? = nil) {
        self.init(frame: CGRect.zero)
        
        // Image View
        if image != nil {
            imageView = UIImageView(image: image!)
            addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cnX = NSLayoutConstraint.init(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 15.0)
            cnY = NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
            cnWidth = NSLayoutConstraint.init(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: image!.size.width)
            cnHeight = NSLayoutConstraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: image!.size.height)
            addConstraints([cnX, cnY, cnWidth, cnHeight])
        }
        
        // Label
        label = createLabel()
        label.text = message
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        if image != nil {
            cnX = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 10.0)
        } else {
            cnX = NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10.0)
        }
        cnY = NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        cnWidth = NSLayoutConstraint.init(item: label, attribute: .right, relatedBy: .equal, toItem: closeButton, attribute: .left, multiplier: 1.0, constant: -12.0)
        cnHeight = NSLayoutConstraint.init(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        addConstraints([cnX, cnY, cnWidth, cnHeight])
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Public
    
    override func prepareForDisplay() {
        startTimer()
        super.prepareForDisplay()
    }
    
    override func removeFromManager() {
        stopTimer()
        super.removeFromManager()
    }
    
    // MARK: - Private
    
    @objc fileprivate func timerDidFinish() {
        removeFromManager()
    }
    
    fileprivate func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: displayTime, target: self, selector: #selector(timerDidFinish), userInfo: nil, repeats: false)
    }
    
    fileprivate func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

}
