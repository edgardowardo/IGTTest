//
//  MastersViewModel.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 21/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

protocol MastersViewModelDelegate {
    /// Schedule notification uses UIKit. So delegate this function over the view controller passing all necessary info from the view model.
    func scheduleNotification(fireDate: NSDate, alertAction: String, alertTitle: String, alertBody: String, withFilename filename: String)
}

class MastersViewModel {

    struct Notification {
        struct Identifier {
            static let showFile = "NotificationIdentifierOf_showFile"
        }
    }
    
    var delegate : MastersViewModelDelegate?
    
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
                    
                    self.delegate?.scheduleNotification(NSDate(timeIntervalSinceNow: 10), alertAction: "Show games", alertTitle: "Games", alertBody: "Congratulations you have new games to play!", withFilename: file)
                }
            }
        }
        task.resume()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(methodOfReceivedNotification_showFile), name: Notification.Identifier.showFile, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc private func methodOfReceivedNotification_showFile(notification : NSNotification) {        
        if let name = notification.object as? String, let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(name), d = NSData(contentsOfURL: fileURL) {
                
            let result = NSString(data: d, encoding: NSASCIIStringEncoding)!
            print(result)
        }
    }
}