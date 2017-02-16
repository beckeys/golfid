//
//  DataFunctions.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/22/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import Foundation
import Parse
import WatchKit

func    doGetClubList() {
    var clubList = [NSString]()
    var clubIDList = [NSString]()
    var clubStatusList = [NSString]()
    
    var myLoc: PFGeoPoint = PFGeoPoint()
    
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    defaults!.setValue("Busy", forKey: "dataState")
    
    NSLog("In doGetClubList, just set busy flag")
    
    myLoc.latitude = defaults!.doubleForKey("latitude")
    myLoc.longitude = defaults!.doubleForKey("longitude")
    
    // NSThread.sleepForTimeInterval(2)
    //       doSpinner()
    
    var nearQuery = PFQuery(className:"USAClubs")
    nearQuery.whereKey("location", nearGeoPoint: myLoc)
    // Limit what could be a lot of points.
    nearQuery.limit = 12        // this seems directly related to the time it takes (was 25)
    
    nearQuery.findObjectsInBackgroundWithBlock{
        (objects, error) -> Void in
        if error == nil {
            NSLog("NearbyClubs Success. Got \(objects!.count) objects")
            for clubRecord in objects as! [PFObject]{
                // NSLog(clubRecord.objectForKey("facility_name") as NSString)
                // there's a potential problem here if either of these things comes back nil
                clubList.append(clubRecord.objectForKey("club_name") as! NSString)
                clubIDList.append(clubRecord.objectForKey("club_id")as! NSString)
                clubStatusList.append(clubRecord.objectForKey("club_membership") as! NSString)
            } //end for
            defaults!.setObject( clubList, forKey: "clubList")
            defaults!.setObject( clubIDList, forKey: "clubIDList")
            defaults!.setObject( clubStatusList, forKey: "clubStatusList")
        } else {
            NSLog("Failure getting Nearby Clubs. Error is \(error)")
        } //end if
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults!.setValue("Ready", forKey: "dataState")
        defaults?.synchronize()
    } // end block
   // NSThread.sleepForTimeInterval(2)
} // end func doGetClubList

func    doGetCourseList() {
    var courseList = [NSString]()
    var courseIDList = [NSString]()
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    var currentClubID: String = defaults!.stringForKey("currentClubID")!
    defaults!.setValue("Busy", forKey: "dataState")

    var courseQuery = PFQuery(className:"USACourses")
    courseQuery.whereKey("club_id", equalTo: currentClubID)
    courseQuery.limit = 6   //max courses at a club
    courseQuery.findObjectsInBackgroundWithBlock{
        (objects, error) -> Void in
        if error == nil {
            NSLog("Finding Courses Success. Got \(objects!.count) objects")
            for courseRecord in objects as! [PFObject]{
                NSLog("This is supposed to be CourseRecord\(courseRecord)")
                // there's a potential problem here if either of these things comes back nil
                courseList.append(courseRecord.objectForKey("course_name") as! NSString)
                courseIDList.append(courseRecord.objectForKey("course_id")as! NSString)
                //defaults!.setObject(courseRecord.objectForKey("course_id")as! NSString, forKey: "currentCourseID")   // we set this even though it's not selected
                // self.doGetTeeList()    // this was when we had both functions in the table controller
            } //end for
            defaults!.setObject( courseList, forKey: "courseList")
            defaults!.setObject( courseIDList, forKey: "courseIDList")
            defaults!.setValue("Ready", forKey: "dataState")
            defaults?.synchronize()
        } else {
            NSLog("Failure getting Club's Courses. Error is \(error)")
            defaults!.setValue("Ready", forKey: "dataState")
            defaults?.synchronize()

            
        } //end if
    } // end block
} // end func doGetClubList

func    doGetTeeList() {
    var teeList = [NSString]()
    var teeIDList = [NSString]()
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    var currentCourseID: String = defaults!.stringForKey("currentCourseID")!
    var teeQuery = PFQuery(className:"USATees")
    defaults!.setValue("Busy", forKey: "dataState")
    teeQuery.whereKey("course_id", equalTo: currentCourseID)
    teeQuery.limit = 12   //max tees per course
    teeQuery.findObjectsInBackgroundWithBlock{
        (objects, error) -> Void in
        if error == nil {
            NSLog("Finding Tees Success. Got \(objects!.count) objects")
            for teeRecord in objects as! [PFObject]{
                NSLog("This is supposed to be TeeRecord\(teeRecord)")
                // there's a potential problem here if either of these things comes back nil
                teeList.append(teeRecord.objectForKey("tee_name") as! NSString)
                teeIDList.append(teeRecord.objectForKey("tee_id")as! NSString)
            } //end for
            defaults!.setObject( teeList, forKey: "teeList")
            defaults!.setObject( teeIDList, forKey: "teeIDList")
            defaults!.setValue("Ready", forKey: "dataState")
            defaults?.synchronize()
        } else {
            NSLog("Failure getting Tees. Error is \(error)")
            defaults!.setValue("Ready", forKey: "dataState")
            defaults?.synchronize()

        } //end if
    } // end block
} // end func doGetClubList


func doLoadScorecard() {
    // copy the scorecard to the NSUserDefaults, so that Watchkit can see it.
    // this happens when we choose a new scorecard
    //get the scorecard data from Parse, based on currentTeeID
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    var scorecardQuery = PFQuery(className:"USATees")
    var currentTeeID = defaults!.stringForKey("currentTeeID")
    defaults!.setValue("Busy", forKey: "dataState")
    scorecardQuery.whereKey("tee_id", equalTo: currentTeeID!)
    scorecardQuery.limit = 1
    scorecardQuery.findObjectsInBackgroundWithBlock{
        (objects, error) -> Void in
        if error == nil {
            NSLog("Scorecard Query got \(objects!.count) objects. It better be one!")
            
            for scorecard in objects as! [PFObject]{
                
                defaults?.setObject(scorecard.objectForKey("tee_name"), forKey: "teeName")
                defaults?.setObject(scorecard.objectForKey("total_distance"), forKey: "totalDistance")
                defaults?.setObject(scorecard.objectForKey("rating"), forKey: "rating")
                defaults?.setObject(scorecard.objectForKey("slope"), forKey: "slope")
                defaults?.setObject(scorecard.objectForKey("course_par_for_tee"), forKey: "courseParForTee")
                
                // now for the 18 possible holes on this course, fill in 
                // holeYards, holeHDCP, holePar arrays
                // count the actual number of holes (up to 18 / 9 / whatever
                NSLog("Looping through holes in scorecard")
                var count:Int
                var par:Int
                var pars = [Int]()
                var hdcp: Int
                var hdcps = [Int]()
                var yards:Int
                var yardss = [Int]()
                var nholes = 0
                
                for count in 1...18 {
                    if ((scorecard.objectForKey("hole\(count)") == nil)){
                        defaults!.setObject( count-1, forKey: "holesInCurrentRound")
                        break
                    } //end if

                    
                    nholes++
                    
                    yards = scorecard.objectForKey("hole\(count)") as! Int
                    par = scorecard.objectForKey("hole\(count)_par") as! Int
                    hdcp = scorecard.objectForKey("hole\(count)_handicap") as! Int
                    if yards == 0 {
                      defaults!.setObject( count-2, forKey: "holesInCurrentRound")
                        break
                    }
                    
                    NSLog("*Hole \(count) Par \(par) yards \(yards)  hdcp \(hdcp)")
                    
                    pars.append(par)
                    hdcps.append(hdcp)
                    yardss.append(yards)
                    
                    
                } //end for
                
                defaults?.setObject(pars, forKey: "holePar")
                defaults?.setObject(hdcps, forKey: "holeHdcp")
                defaults?.setInteger(nholes, forKey: "holesInCurrentRound")
                defaults?.setObject(yardss, forKey: "holeYards")
                
                // and clear the user data for this scorecard
                doClearUserRound()
                
                //start the round by setting the roundStartTimeStamp
                
                let starttime = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                defaults?.setObject(starttime, forKey: "roundStartTimestamp")
                defaults?.setBool(true, forKey: "roundInProgress")
                defaults!.setValue("Ready", forKey: "dataState")
                defaults?.synchronize()

            } // end for
        }
    }
}

func doClearUserRound() {
    //  we wouldn't do this if there was a round in progress
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    var rip: Bool = defaults!.boolForKey("roundInProgress")
    if rip {
        NSLog("Trying to erase a round in progress, this is bad.")          /////   This will need to change to the appState SWITCH
        exit(EXIT_FAILURE)
    } // endif
    
    var rawScores = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var escScores = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var putts = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var girFlag = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var fairFlag = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var holeLocked = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var holeTimestamp = ["","","","","","","","","","","","","","","","","",""]
    
    defaults?.setObject(rawScores, forKey: "rawScores")
    defaults?.setObject(escScores, forKey: "escScores")
    defaults?.setObject(putts, forKey: "putts")
    defaults?.setObject(girFlag, forKey: "girFlag")
    defaults?.setObject(fairFlag, forKey: "fairFlag")
    defaults?.setObject(holeLocked, forKey: "holeLocked")
    defaults?.setObject(holeTimestamp, forKey: "holeTimestamp")
    
    defaults?.setObject("unknown", forKey: "userGHIN")
    
    defaults?.setInteger(1, forKey: "currentHole")
    defaults?.setInteger(0, forKey: "currentHoleScore")
    defaults?.setInteger(0, forKey: "roundScore")
    
    let date = NSDate()
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    defaults?.setObject(formatter.stringFromDate(date), forKey: "roundStartTimestamp")
    defaults?.setObject("", forKey: "roundStopTimestamp")

}

func doSaveScorecard(){
    
    //save this Scorecard to user rounds in Parse
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    defaults?.synchronize()
    var rip: Bool = defaults!.boolForKey("roundInProgress")
    
    var userRound = PFObject(className:"UserRound")
    
    let name:String = defaults!.stringForKey("userName")!
    let uid:String = defaults!.stringForKey("userID")!
    
    let strt:String = defaults!.stringForKey("roundStartTimestamp")!
    let stop:String = defaults!.stringForKey("roundStopTimestamp")!
    let gss:String = defaults!.stringForKey("roundSummaryString")!
    let clb:String = defaults!.stringForKey("currentClub")!
    let clid:String = defaults!.stringForKey("currentClubID")!
    let crs:String = defaults!.stringForKey("currentCourse")!
    let crid:String = defaults!.stringForKey("currentCourseID")!
    let hir:Int = defaults!.integerForKey("holesInCurrentRound")
    let te:String = defaults!.stringForKey("currentTee")!
    let tid:String = defaults!.stringForKey("currentTeeID")!
    let raw = defaults!.arrayForKey("rawScores")!
    let esc = defaults!.arrayForKey("escScores")!
    let putt = defaults!.arrayForKey("putts")!
    let gir = defaults!.arrayForKey("girFlag")!
    let fwh = defaults!.arrayForKey("fairFlag")!
    

    
        userRound["userName"] = name
        userRound["userID"] = uid
//        userRound["userGHIN"] = ghin
        userRound["startTimestamp"] = strt
        userRound["stopTimestamp"] = stop
        userRound["club"] = clb
        userRound["clubID"] = clid
    
        userRound["course"] = crs
        userRound["courseID"] = crid
    
        userRound["tee"] = te
        userRound["currentTeeID"] = tid
    
        userRound["holesInRound"] = hir
    
        userRound["rawScores"] = raw
        userRound["escScores"] = esc
       userRound["putts"] = putt
    
        userRound["girFlag"] = gir
        userRound["fairFlag"] = fwh
        userRound["roundSummaryString"] = gss
    
    
        userRound.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    
}

func doRoundJournal(){
    
    // later
    
}

func    doGetUserRounds() {
    var gameClubList = [NSString]()
    var gameSummaryList = [NSString]()

    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")

    var ID = defaults?.objectForKey("userID") as! String

    
    
    NSLog("In doGetUserRounds for \(ID)")
    
    
    
    var roundsQuery = PFQuery(className:"UserRound")
    roundsQuery.whereKey("userID", equalTo: ID)

    roundsQuery.findObjectsInBackgroundWithBlock{
        (objects, error) -> Void in
        if error == nil {
            NSLog("User Rounds Fetch Success. Got \(objects!.count) objects")
            for gameRecord in objects as! [PFObject]{
                // NSLog(clubRecord.objectForKey("facility_name") as NSString)
                // there's a potential problem here if either of these things comes back nil
                gameClubList.append(gameRecord.objectForKey("club") as! NSString)
                var summary = gameRecord.objectForKey("roundSummaryString") as! NSString
                gameSummaryList.append(summary)
            } //end for
        } else {
            NSLog("User Rounds. Error is \(error)")
        } //end ifFilipe
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults?.setObject(gameClubList, forKey: "userRounds")
        defaults?.setObject(gameSummaryList, forKey: "roundSummaries")
        defaults!.setValue("Ready", forKey: "dataState")
        defaults?.synchronize()
    } // end block
    // NSThread.sleepForTimeInterval(2)
} // end func doGetClubList


   