//
//  AppDelegate.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert], categories: nil))
        
        if let o = launchOptions, notification = o[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            handleNotification(notification, forApplication: application)
        }
        return true
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        handleNotification(notification, forApplication: application)
    }
    
    func handleNotification(notification : UILocalNotification, forApplication application : UIApplication) {
        var title = "Hello there!"
        if #available(iOS 8.2, *) {
            title = notification.alertTitle!
        }
        let a = UIAlertController(title: title, message: notification.alertBody!, preferredStyle: UIAlertControllerStyle.Alert)
        a.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
   
        if let file = notification.userInfo?["file"] as? String, fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(file), d = NSData(contentsOfURL: fileURL) {
            
            let result = NSString(data: d, encoding: NSASCIIStringEncoding)!
            print(result)
        }
        
//        if let notificationId = notification.userInfo?["notificationId"] as? String, notification = realm.objects(NotificationObject).filter("id == '\(notificationId)'").first {
//            
//            showCurrentObjectFromNotification(notification)
//        }
        
        //read
//        if let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(file) {
//            
//            if let d = NSData(contentsOfURL: fileURL) {
//                let result = NSString(data: d, encoding: NSASCIIStringEncoding)!
//                print(result)
//            }
//        }
        
        
        self.window?.rootViewController?.presentViewController(a, animated: true, completion: nil)
        
        
//        self.window?.visibleViewController?.presentViewController(a, animated: true, completion: nil)
    }
    

}

