//
//  NearbyClubsViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/20/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit
import Parse

class NearbyClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nearbyTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        doDispatch()    //check state machine, transfer if necessary
        NSLog("In Nearby, going to get club list")
        doGetClubList()
        doWaitForReady()
        killSpinner()
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var clubList = defaults!.arrayForKey("clubList")
        var clubIDList = defaults!.arrayForKey("clubIDList")
        NSLog("ClubList: \(clubList)")
        NSLog("ClubIDList: \(clubIDList)")
        self.nearbyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }   //end func ViewDidLoad
    
    override func viewDidAppear(animated: Bool) {
 
          }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        doWaitForReady()
        var clubList = defaults!.arrayForKey("clubList")
        

        
        return clubList!.count
    }   //end func tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.nearbyTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        //apparently we need to set the cell style here if we want the detailTextLabel to show up
          //  cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "cell")
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var clubList: Array = defaults!.arrayForKey("clubList")!
        var clubStatus: Array = defaults!.arrayForKey("clubStatusList")!
        
        var index = indexPath.row as Int
        var text = clubList[index] as! String
        var subtext = clubStatus[index] as! String

        cell.textLabel?.text = text
        cell.detailTextLabel?.text = subtext
        
        return cell
    }   //end func tableview
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this happens when the user selects a row in the table
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var clubList: Array = defaults!.arrayForKey("clubList")!
        var clubIDList: Array = defaults!.arrayForKey("clubIDList")!
        
        var index = indexPath.row as Int
        
        NSLog("selected \(index)")
        
        var currentClub: String = clubList[index] as! String
        var currentClubID: String = clubIDList[index] as! String
        
        defaults!.setObject(currentClub, forKey: "currentClub")
        defaults!.setObject(currentClubID, forKey: "currentClubID")
        NSLog("club: \(currentClub)   ID: \(currentClubID)")
        
        //segue to the Course and Tee View Controller
        
        self.performSegueWithIdentifier("SegueToCourse", sender: nil)
        
    }   //end func tableview
    
    func doSpinner() -> Void {
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        // UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }   //end func spinner
    
    
    func killSpinner() -> Void {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func doDispatch() {
            var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
            var appState = defaults!.stringForKey("appState")
            var dataWait = defaults!.stringForKey("dataState")
        NSLog("In NearbyController AppState: \(appState)  DataWait: \(dataWait)")
        
            
            if dataWait != "Ready" {
                NSLog("Not 'Ready' in DoDispatch in Nearby Controller, forcing...")
                defaults!.setValue("ClubSelect", forKey: "appState")
                defaults!.setValue("Ready", forKey: "dataState")
            }
            if appState != "ClubSelect" { // we don't belong here
                switch appState! {    //ClubSelect, CourseSelect, TeeSelect, RoundInProgress

                case "CourseSelect":
                self.performSegueWithIdentifier("segueToCourse", sender: nil)
                case "TeeSelect":
                self.performSegueWithIdentifier("segueToTee", sender: nil)
                case "RoundInProgress":
                self.performSegueWithIdentifier("SegueGameInProgress", sender: nil)
                default:
                defaults!.setValue("ClubSelect", forKey: "appState") // didn't get initialized?
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