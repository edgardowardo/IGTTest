//
//  MasterViewController.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var viewModel = MastersViewModel()
    private var myContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.title
        self.viewModel.delegate = self

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        viewModel.addObserver(self, forKeyPath: "model", options: .New, context: &myContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let _ = change?[NSKeyValueChangeNewKey] {
                self.tableView.reloadData()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    deinit {
        viewModel.removeObserver(self, forKeyPath: "model", context: &myContext)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = viewModel.model {
            return m.data.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        let game = viewModel.model!.data[indexPath.row]
        cell.viewModel = MasterViewModel(model: game)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}

extension MasterViewController : MastersViewModelDelegate {
    func scheduleNotification(fireDate: NSDate, alertAction: String, alertTitle: String, alertBody: String, withFilename filename: String) {
        let application = UIApplication.sharedApplication()
        application.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = fireDate
        notification.alertAction = alertAction
        if #available(iOS 8.2, *) {
            notification.alertTitle = alertTitle
        }
        notification.alertBody = alertBody
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["showFile": filename]
        application.scheduleLocalNotification(notification)
    }
}

