//
//  InternalNotificationManager.swift
//  TearBud
//
//  Created by Michael Rose on 12/1/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

/* Managages views that confirm to the InternalNotification protocol and displays them on screen */

class InternalNotificationManager {
    
    static let shared = InternalNotificationManager()
    
    fileprivate var notificationWindow: UIWindow!
    fileprivate var notificationViewController: InternalNotificationViewController!
    
    fileprivate var queue = [InternalNotificationView]()
    fileprivate var sortedQueue: [InternalNotificationView] {
        return queue.sorted { $0.priority.rawValue == $1.priority.rawValue ? $0.dateCreated < $1.dateCreated : $0.priority.rawValue > $1.priority.rawValue }
    }
    fileprivate var notificationProcessRunning = false
    
    // We want the internal notification bar to be slightly taller than the status bar
    fileprivate let statusBarHeightOffset: CGFloat = 10.0
    
    fileprivate init() {
        // Register for status bar frame changes
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarFrameWillChange), name: Notification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        
        // Current status bar height
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let notificationBarHeight = statusBarHeight + statusBarHeightOffset
        
        // Init Notification Window
        notificationWindow = UIWindow(frame: CGRect(x: 0, y: -notificationBarHeight, width: UIScreen.main.bounds.width, height: notificationBarHeight))
        notificationWindow.windowLevel = UIWindowLevelStatusBar + 1
        notificationWindow.backgroundColor = UIColor.clear
        notificationWindow.isHidden = true
        
        // Init Notification View Controller
        notificationViewController = InternalNotificationViewController()
        notificationWindow.rootViewController = notificationViewController
    }
    
    deinit {
        // Clear queue
        clearQueue()
        
        // Unregister for status bar frame changes
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
        
    }
    
    // MARK: - Notifiation Management
    
    func queue(notification: InternalNotificationView) {
        // Add notification to the queue
        queue.append(notification)
        
        // Become delegate
        notification.delegate = self
        
        // Attempt to start notification dispaly process (could already be running)
        beginNotifcationProcess()
    }
    
    // MARK: - Internal
    
    // Starts to the process of running through the queue until it's empty
    fileprivate func beginNotifcationProcess() {
        // Check if the process is already running, or there are no notifications in the queue
        if notificationProcessRunning || queue.count <= 0 { return }
        
        // Set flag to true
        notificationProcessRunning = true
        
        // Show the notification bar
        showNotificationBar()
        
        // Load next notification
        loadNextNotification()
    }
    
    fileprivate func loadNextNotification() {
        if let notification = sortedQueue.first {
            // Add the notification to the notification view controller hierarchy for display
            notificationViewController.transitionToInternalNotificationView(toView: notification, completion: { (completed) in
                if completed {
                    // Tell the notification it's about to be displayed
                    notification.prepareForDisplay()
                }
            })
        } else {
            endNotificationProcess()
        }
    }
    
    // Called when the queue is emptied
    fileprivate func endNotificationProcess() {
        
        // Set flag to false
        notificationProcessRunning = false
        
        // Clear queue
        clearQueue()
        
        // Clear notification view controller hierarchy
        notificationViewController.transitionToInternalNotificationView(toView: nil)
        
        // Hide the notificaiton bar
        hideNotificationBar()
    }
    
    fileprivate func clearQueue() {
        for notification in queue {
            notification.delegate = nil
        }
        queue.removeAll()
    }
    
    fileprivate func showNotificationBar() {
        notificationWindow.isHidden = false
        
        var frame = notificationWindow.frame
        frame.origin.y = 0
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .beginFromCurrentState, animations: { 
            self.notificationWindow.frame = frame
        }) { (completed) in
            //
        }
        
        notificationViewController.showShadowView()
    }
    
    fileprivate func hideNotificationBar() {
        var frame = notificationWindow.frame
        frame.origin.y = -frame.size.height
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .beginFromCurrentState, animations: {
            self.notificationWindow.frame = frame
        }) { (completed) in
            if completed { self.notificationWindow.isHidden = false }
        }
        
        notificationViewController.hideShadowView()
    }
    
    // MARK: - Application Notifications
    
    @objc func statusBarFrameWillChange(notification: Notification) {
        if let value = notification.userInfo?[UIApplicationStatusBarFrameUserInfoKey] as? NSValue {
            let statusBarHeight = value.cgRectValue.size.height
            let notificationBarHeight = statusBarHeight + statusBarHeightOffset
            
            var frame = notificationWindow.frame
            frame.size.height = notificationBarHeight
    
            UIView.animate(withDuration: 0.35, delay: 0, options: .beginFromCurrentState, animations: { 
                self.notificationWindow.frame = frame
                self.notificationViewController.currentNotification?.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

extension InternalNotificationManager: InternalNotificationViewDelegate {

    func userDidTapInternalNotificationView(notification: InternalNotificationView) {
        /*
        if appDelegate.rootViewController.presentedViewController == nil {
            let tearBudInfo = UIStoryboard(name: "TearBudInfo", bundle: nil).instantiateViewController(withIdentifier: "TearBudInfoViewController")
            let navigationController = UINavigationController(rootViewController: tearBudInfo)
            appDelegate.rootViewController.present(navigationController, animated: true, completion: nil)
        }
        */
    }
    
    func internalNotificationViewDidFinish(notification: InternalNotificationView) {
        // Kill the finished notification (remove from queue, and clear delegate)
        notification.delegate = nil
        if let index = queue.index(of: notification) {
            queue.remove(at: index)
        }
    
        // If the complete notification is the current notification, then try to load the next notification
        // It is possible a notification will finish before it's even displayed (sync progress)
        if notification == notificationViewController.currentNotification { loadNextNotification() }
    }
    
}
