//
//  IGTTestTests.swift
//  IGTTestTests
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import XCTest
@testable import IGTTest

class IGTTestTests: XCTestCase {
    
    let mc = MasterViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMastersViewModel() {
        let e = expectationWithDescription("Get drop box data")
        mc.viewModel.setup(3) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            XCTAssertEqual(response!.URL!.absoluteString, "https://dl.dropboxusercontent.com/u/49130683/nativeapp-test.json", "HTTP response URL should be equal to original URL")
            
            let application = UIApplication.sharedApplication()
            XCTAssertNotNil(application.scheduledLocalNotifications, "scheduledLocalNotifications should not be nil")
            
            let name = "data"
            if let fileURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(name), d = NSData(contentsOfURL: fileURL) {
                
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
                    if let d = dictionary, res = d["response"] as? String, dataDict = d["data"] as? [NSDictionary] {
                        XCTAssertEqual(res, "success", "response should be succcess" )
                        XCTAssertGreaterThan(dataDict.count, 0)
                        // Manually trigger notification since not possible to simulate the arrival of the NSLocalNotification.
                        NSNotificationCenter.defaultCenter().postNotificationName(MastersViewModel.Notification.Identifier.showFile, object: "data")
                        let count = self.mc.viewModel.model!.data.count
                        XCTAssertGreaterThan(count, 0)
                    } else {
                        XCTAssertFalse(true, "could not be parsed")
                    }
                } catch let error as NSError {
                    XCTAssertFalse(true, "\(error)")
                }
            }
            
            e.fulfill()
        }
        
        waitForExpectationsWithTimeout(60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testMasterViewModel() {
        let cell = MasterTableViewCell()
        let game = Game(name: "Game 0", jackpot: 0, date: NSDate())
        cell.viewModel = MasterViewModel(model: game)
        
        XCTAssertEqual(cell.textLabel!.text, "Game 0")
    }
    
    func testGameViewModel() {

        NSUserDefaults.standardUserDefaults().setObject(["es"], forKey: "AppleLanguages")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let d = nsdateFromString("2015-01-25T20:20:30+01:00")!
        let vm = GameViewModel(currency: "GBP", model: Game(name: "Game 0", jackpot: 100000, date: d))
        XCTAssertEqual(vm.title, "Game 0")
        XCTAssertEqual(vm.currency, "GBP")
        
        let os = NSProcessInfo().operatingSystemVersion
        switch (os.majorVersion, os.minorVersion, os.patchVersion) {
        case (8, 0..<2, _):
            XCTAssertEqual(vm.jackpot, "100.000,00 GBP")
            XCTAssertEqual(vm.date, "25/1/2015 19:20")
        default:
            XCTAssertEqual(vm.jackpot, "£100,000.00")
            XCTAssertEqual(vm.date, "Jan 25, 2015, 7:20 PM")
        }        
    }
}

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}

func nsdateFromString(string : String) -> NSDate? {
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
