//
//  MastersViewModel.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 21/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

protocol MastersViewModelDelegate {
    /// Use local notification to schedule expiration. NSTime, GCD and NSOperationQueue will canccel expiration if app is manually killed.
    /// This way with local notification, the user is prompted even when the app is not running. Schedule notification uses UIKit. 
    /// We do not want UIKit in the view model. So use a delegate to perform this task over the view controller passing all necessary 
    /// info from the view model.
    func scheduleNotification(fireDate: NSDate, alertAction: String, alertTitle: String, alertBody: String, withFilename filename: String)
}

class MastersViewModel : NSObject {

    /// Key used for NSNotification coming from the AppDelegate's callback on the local notification with payload. Maybe there's a
    /// more elegant solution than this. I tried to parse the navigation tree from the AppDelegate but it looked very hacky and ugly.
    struct Notification {
        struct Identifier {
            static let showFile = "NotificationIdentifierOf_showFile"
        }
    }
    
    var delegate : MastersViewModelDelegate?
    
    /// The viewModel inherits from NSObject since we are using KVO to inform the view controller of changes to the model. An 
    /// Alternative to KVO is NSNotification, however this has global scope and breaks local reasoning. If allowed, I would have used
    /// RxSwift to observe state changes since it's more elegant and easier to use.
    dynamic var model : MasterList?
    
    var title : String {
        return "IGT"
    }
    
    var currency : String {
        if let m = model {
            return m.currency
        } else {
            return ""
        }
    }
    
    override init() {
        super.init()
        setup()
    }
    
    func setup(timeInterval: NSTimeInterval = 60 * 60, withCallback : ((data: NSData?, response: NSURLResponse?, error: NSError?)-> Void)? = nil ) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://dl.dropboxusercontent.com/u/49130683/nativeapp-test.json")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    guard let rawdata = data else { return }
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(rawdata, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
                    if let d = dictionary, res = d["response"] as? String where res == "success" {
                        let file = "data"
                        //write
                        if let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(file), d = data where d.writeToURL(fileURL, atomically: true) {
                            
                            self.delegate?.scheduleNotification(NSDate(timeIntervalSinceNow: timeInterval), alertAction: "Show games", alertTitle: "Games", alertBody: "Congratulations you have new games to play!", withFilename: file)
                        }
                    } else {
                        print("could not be parsed")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            if let callback = withCallback {
                callback(data: data, response: response, error: error)
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

            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
                if let d = dictionary, currency = d["currency"] as? String, dataDict = d["data"] as? [NSDictionary] {
                    let data = dataDict.map({ d -> Game in
                        var name = ""
                        if let n = d["name"] as? String {
                            name = n
                        }
                        var jackpot = 0
                        if let j = d["jackpot"] as? Int {
                            jackpot = j
                        }
                        var date = NSDate()

                        if let dateRaw = d["date"] as? String, dateFormatted = nsdateFromString(dateRaw) {
                            date = dateFormatted
                        }
                        return Game(name: name, jackpot: jackpot, date: date)
                    })
                    self.model = MasterList(currency: currency, data: data)
                } else {
                    print("could not be parsed")
                }
//                print(dictionary)
            } catch let error as NSError {
                print(error)
            }
        }
    }
        
    private func nsdateFromString(string : String) -> NSDate? {
        let formatter = NSDateFormatter()
        let locale = NSBundle.mainBundle().preferredLocalizations.first ?? "en_UK"
        formatter.locale = NSLocale(localeIdentifier: locale)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let date = formatter.dateFromString(string) else {
            assert(false, "no date from string")
            return nil
        }
        
        return date
    }
}
