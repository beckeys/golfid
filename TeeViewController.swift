//
//  TeeViewController.swift
//  Golf-e Scorecard
//
//
//  Created by Scott Beckey on 4/20/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit

class TeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teeTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("tee view controller load!")
        
        //doSpinner()
        
        doGetTeeList()
        NSThread.sleepForTimeInterval(2)
        
        //killSpinner()
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults?.synchronize()
        var teeList = defaults!.arrayForKey("teeList")
        var teeIDList = defaults!.arrayForKey("teeIDList")
        
        NSLog("teeList: \(teeList)")
        NSLog("teeIDList: \(teeIDList)")
        
        self.teeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
    }   //end func ViewDidLoad
    
    override func viewDidAppear(animated: Bool) {
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults!.setValue("TeeSelect", forKey: "appState")
     

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var teeList = defaults!.arrayForKey("teeList")
        
        return teeList!.count
    }   //end func tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.teeTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var teeList: Array = defaults!.arrayForKey("teeList")!
        
        var index = indexPath.row as Int
        var text = teeList[index] as! String
        
        cell.textLabel?.text = text
        
        return cell
    }   //end func tableview
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this happens when the user selects a row in the table
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var teeList: Array = defaults!.arrayForKey("teeList")!
        var teeIDList: Array = defaults!.arrayForKey("teeIDList")!
        
        var index = indexPath.row as Int
        
        NSLog("selected \(index)")
        NSLog("teelist: \(teeList)")
        NSLog("teeIDs: \(teeIDList)")
        
        
        var currentTee: String = teeList[index] as! String
        var currentTeeID: String = teeIDList[index] as! String
        defaults?.synchronize()
        
        defaults!.setObject(currentTee, forKey: "currentTee")
        defaults!.setObject(currentTeeID, forKey: "currentTeeID")
        defaults!.setValue("RoundInProgress", forKey: "appState")
        defaults?.synchronize()
        NSLog("tee: \(currentTee)   ID: \(currentTeeID)")
        
        doLoadScorecard()
        
        //segue from here to Hole Controller (finally)
        self.performSegueWithIdentifier("SegueToHole", sender: nil)
        
    }   //end func tableview
    
    
}