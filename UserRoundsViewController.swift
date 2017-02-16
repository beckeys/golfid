//
//  UserRoundsViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/30/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit
import Parse



class UserRoundsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roundsTableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        doGetUserRounds()
  
        self.roundsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var roundList = defaults?.arrayForKey("userRounds")
        if roundList == nil { return 0 }
        return roundList!.count
    }   //end func tableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.roundsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var index = indexPath.row as Int
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var roundList: Array = defaults!.arrayForKey("userRounds")!
        var subtex: String = ""
        NSLog(" Roundlist: \(roundList)")
        if defaults?.arrayForKey("roundSummaries") != nil {
                var summaries: Array = defaults!.arrayForKey("roundSummaries")!
                subtex = summaries[index] as! String
        } else {
            subtex = "Not Available"
        }

        var tex = roundList[index] as! String


        
        cell.textLabel!.text = tex
        cell.detailTextLabel!.text = subtex
        
        
        
        
        return cell
    }   //end func tableview
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this happens when the user selects a row in the table
        
         var index = indexPath.row as Int
        
        NSLog("selected \(index)")
        
      
    }   //end func tableview

    
    @IBAction func backButton(sender: AnyObject) {
        self.performSegueWithIdentifier("SegueBackFromUserRounds", sender: nil)
    } // end back button
    
    
 

} // end class

