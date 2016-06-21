//
//  MasterViewModel.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit
import Foundation

struct MasterViewModel {
    
    init() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://dl.dropboxusercontent.com/u/49130683/nativeapp-test.json")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let file = "data"
                //write
                if let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(file), d = data {
                    
                    d.writeToURL(fileURL, atomically: true)
                    
                    // TODO: Move to UIViewController
                    let application = UIApplication.sharedApplication()
                    application.cancelAllLocalNotifications()
                    
                    let notification = UILocalNotification()
                    notification.timeZone = NSTimeZone.defaultTimeZone()
                    notification.fireDate = NSDate(timeIntervalSinceNow: 10)
                    notification.alertAction = "Show games"
                    if #available(iOS 8.2, *) {
                        notification.alertTitle = "Games"
                    }
                    notification.alertBody = "Congratulations you have new games!"
                    notification.soundName = UILocalNotificationDefaultSoundName
                    notification.userInfo = ["showFile": file]
                    application.scheduleLocalNotification(notification)
                }                
            }
        }
        task.resume()
    }
}