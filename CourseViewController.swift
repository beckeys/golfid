//
//  CourseViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/20/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var courseTableView: UITableView!

    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

            NSLog("In course view controller!")
            
            var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
            
            defaults!.setValue("SelectCourse", forKey: "appState")
            defaults?.synchronize()
            
            doDispatch()    //check state machine, transfer if necessary
            //doSpinner()
            doGetCourseList()
            
            // wait for ready here
            
            doWaitForReady()
            
            
            //killSpinner()
            
            
            
            var courseList = defaults!.arrayForKey("courseList")
            var courseIDList = defaults!.arrayForKey("courseIDList")
            
            NSLog("CourseList: \(courseList)")
            NSLog("CourseIDList: \(courseIDList)")
            
            
            self.courseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
     
    }   //end func ViewDidLoad
    
    
    override func viewDidAppear(animated: Bool) {
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var courseList = defaults!.arrayForKey("courseList")
        
        return courseList!.count
    }   //end func tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.courseTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var courseList: Array = defaults!.arrayForKey("courseList")!
        
        var index = indexPath.row as Int
        var text = courseList[index] as! String
        
        cell.textLabel?.text = text
        
        return cell
    }   //end func tableview
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this happens when the user selects a row in the table
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var courseList: Array = defaults!.arrayForKey("courseList")!
        var courseIDList: Array = defaults!.arrayForKey("courseIDList")!
        
        var index = indexPath.row as Int
        
        NSLog("selected \(index)")
        
        var currentCourse: String = courseList[index] as! String
        var currentCourseID: String = courseIDList[index] as! String
        
        defaults!.setObject(currentCourse, forKey: "currentCourse")
        defaults!.setObject(currentCourseID, forKey: "currentCourseID")
        defaults?.synchronize()
        NSLog("course \(currentCourse)   ID: \(currentCourseID)")

        //segue from here to Tee Controller
        self.performSegueWithIdentifier("SegueToTee", sender: nil)
        
    }   //end func tableview
    
    func doDispatch() {
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var appState = defaults!.stringForKey("appState")
        var dataWait = defaults!.stringForKey("dataState")
        NSLog("In Courses Controller AppState: \(appState)  DataWait: \(dataWait)")
        
        if dataWait != "Ready" {
            NSLog("Not 'Ready' in DoDispatch, forcing Ready State")
            defaults!.setValue("ClubSelect", forKey: "appState")
            defaults!.setValue("Ready", forKey: "dataState")
        }
        if appState != "CourseSelect" { // we don't belong here
            switch appState! {    //ClubSelect, CourseSelect, TeeSelect, RoundInProgress
                
            case "ClubSelect":
                self.performSegueWithIdentifier("segueToNearby", sender: nil)  // I'm guessing I have to make all new segues for these, since we're coming from the course controller..   we will see....
            case "TeeSelect":
                self.performSegueWithIdentifier("segueToTeeViewController", sender: nil)
            case "RoundInProgress":
                self.performSegueWithIdentifier("SegueGameInProgress", sender: nil)
            default:
                defaults!.setObject("ClubSelect", forKey: "appState") // didn't get initialized?
                self.performSegueWithIdentifier("segueToNearby", sender: nil)
            } // end switch
        } // endif
        
    } //end func dodispatch

    func doWaitForReady(){
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var appState = defaults!.stringForKey("appState")
        var dataWait = defaults!.stringForKey("dataState")
        var stuck = 0
        while dataWait != "Ready" {
            NSLog("WaitForReady \(appState): \(dataWait)")
            NSThread.sleepForTimeInterval(1)
            defaults?.synchronize()
            dataWait = defaults!.stringForKey("dataState")
            stuck++
            if stuck > 3 {
                NSLog("Stuck Exit")
                return}
        }
    } // end func datawait

    
}