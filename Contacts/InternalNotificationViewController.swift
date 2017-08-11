//
//  InternalNotificationViewController.swift
//  TearBud
//
//  Created by Michael Rose on 12/1/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

class InternalNotificationViewController: UIViewController {
    
    var contentView: UIView!
    var currentNotification: InternalNotificationView?
    
    fileprivate var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View
        view.backgroundColor = UIColor.clear
        
        // Shadow View
        shadowView = UIView(frame: view.bounds)
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        shadowView.backgroundColor = UIColor.white
        shadowView.alpha = 0
        shadowView.isHidden = true
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowOpacity = 0.13
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        view.addSubview(shadowView)
        
        // Content View
        contentView = UIView(frame: view.bounds)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = UIColor.white
        view.addSubview(contentView)
        
        if currentNotification != nil {
            transitionToInternalNotificationView(toView: currentNotification!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //
    }
    
    func showShadowView() {
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.35, delay: 0, options: .beginFromCurrentState, animations: { 
            self.shadowView.alpha = 1.0
        }, completion: nil)
    }
    
    func hideShadowView() {
        UIView.animate(withDuration: 0.35, delay: 0, options: .beginFromCurrentState, animations: { 
            self.shadowView.alpha = 0
        }) { (completed) in
            if completed { self.shadowView.isHidden = true }
        }
    }

    func transitionToInternalNotificationView(toView: InternalNotificationView?, completion: ((Bool) -> Swift.Void)? = nil) {
        currentNotification = toView
        
        if view != nil { // Come back after viewDidLoad()
            if toView != nil {
                toView!.frame = contentView.bounds
                toView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                UIView.transition(with: contentView, duration: 0.35, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
                    if let fromView = self.contentView.subviews.first {
                        fromView.removeFromSuperview()
                    }
                    self.contentView.addSubview(toView!)
                }, completion: { (completed) in
                    if completion != nil { completion!(completed) }
                })
            } else {
                UIView.transition(with: contentView, duration: 0.35, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
                    if let fromView = self.contentView.subviews.first {
                        fromView.removeFromSuperview()
                    }
                }, completion: { (completed) in
                    if completion != nil { completion!(completed) }
                })
            }
        } else {
            if completion != nil { completion!(false) }
        }
    }
    

}
