//
//  UserContext.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/18/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import Foundation


// This file defines the state of the App at any given moment
// It has the shared elements that are stored in NSUserDefaults
// We don't cache NSUserDefaults, instead we use these functions to get and put data as needed


func initContext () {
    
    //Note that userID and username are already set by Splash
    
    var appState = "ClubSelect"  // ClubSelect, CourseSelect, TeeSelect, RoundInProgress
    var dataState = "Ready"      // Waiting
    
    //User Information
    var allGolfClubs:NSArray = ["Driver", "3 Wood", "5 Wood", "1 Iron", "2 Iron", "3 Iron", "4 Iron", "5 Iron", "6 Iron", "7 Iron", "8 Iron", "9 Iron","Hybrid 2", "Hybrid 3", "Hybrid 4", "Hybrid 5"," Hybrid 6", "Hybrid 7", "Pitching Wedge", "Sand Wedge", "Putter"]
    var userGolfClubs: NSArray = [true, true, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true]
    
    var userLogin: Bool = false
    var userName:String = ""
    var userID:String = ""
    var roundInProgress: Bool = false
    var userPwd:String = ""
    var userGHIN: String = "0"
    var userEmail: String = ""
    var userHomeClub: String = ""           //optional, might need for GHIN posting
    var userOptIn: Bool = true
    var latitude = 0.0
    var longititude = 0.0
    
    //Club Information
    var currentClub = "MysteryClub"
    var currentClubID = "NoneYet"
    var currentClubStatus = "Private"

    //CourseInformation
    var currentCourse = "MyCourse"
    var currentCourseID = "NoneYet"
    
    //Tee Information
    var currentTee = "whichever"
    var currentTeeID = "NoneYet"
    var holesInCurrentRound = 18
    var holePar = [4,3,4,2,4,1,5,3,5,1,2,5,5,3,5,3,4,5]         //example data only, this is overwritten by parse Scorecard data
    var holeHdcp = [18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
    var holeYards = [244,185,120,301,280,124,312,200,222,130,181,244,301,333,121,250,241,265]

    //Scorecard Information
    var rawScores = [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var escScores = [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var putts = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var girFlag = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var fairFlag = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var holeLocked = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    var holeTimestamp = [NSString] () // timestamps for completion of each hole
    
    //Round Information
    var roundStartTimestamp = ""
    var roundStopTimestamp = ""
    var roundScore: Int = 0

    //HoleInformation
    var currentHole:Int = 1
    var currentLie = "Tee"
    var currentHoleScore = 0
    
    let appGroupID = "group.com.golfid.appgroup"
    let defaults = NSUserDefaults(suiteName: appGroupID)
    
    // now we simply initialize all these in NSUserDefaults
    defaults!.setValue("SSB", forKey: "Initials")
    defaults!.setValue(allGolfClubs, forKey: "allGolfClubs")
    defaults!.setValue(allGolfClubs, forKey: "allGolfClubs")
    defaults!.setValue(userGolfClubs, forKey: "userGolfClubs")
    defaults!.setValue(userLogin, forKey: "userLogin")
    defaults!.setValue(userName, forKey: "userName")
    defaults!.setValue(userID, forKey: "userID")
    defaults!.setValue(userPwd, forKey: "userPwd")
    defaults!.setValue(userGHIN, forKey: "userGHIN")
    defaults!.setValue(userEmail, forKey: "userEmail")
    defaults!.setValue(userHomeClub, forKey: "userHomeClub")
    defaults!.setValue(userOptIn, forKey: "userOptIn")
    defaults!.setValue(currentClub, forKey: "currentClub")
    defaults!.setValue(currentClubID, forKey: "currentClubID")
    defaults!.setValue(currentClubStatus, forKey: "currentClubStatus")
    defaults!.setValue(currentCourse, forKey: "currentCourse")
    defaults!.setValue(currentCourseID, forKey: "currentCourseID")
    defaults!.setValue(currentTee, forKey: "currentTee")
    defaults!.setValue(holesInCurrentRound, forKey: "holesInCurrentRound")
    defaults!.setValue(holePar, forKey: "holePar")
    defaults!.setValue(holeHdcp, forKey: "holeHdcp")
    defaults!.setValue(rawScores, forKey: "rawScores")
    defaults!.setValue(escScores, forKey: "escScores")
    defaults!.setValue(putts, forKey: "putts")
    defaults!.setValue(girFlag, forKey: "girFlag")
    defaults!.setValue(fairFlag, forKey: "fairFlag")
    defaults!.setValue(holeLocked, forKey: "holeLocked")
    defaults!.setValue(holeTimestamp, forKey: "holeTimedtamp")
    defaults!.setValue(roundStartTimestamp, forKey: "roundStartTimestamp")
    defaults!.setValue(roundStopTimestamp, forKey: "roundStopTimestamp")
    defaults!.setValue(roundScore, forKey: "roundScore")
    defaults!.setValue(currentHole, forKey: "currentHole")
    defaults!.setValue(currentLie, forKey: "currentLie")
    defaults!.setValue(currentHoleScore, forKey: "currentHoleScore")
    
    // these two are used to sync with the watchkit
    
        defaults!.setValue(appState, forKey: "appState")
        defaults!.setValue(dataState, forKey: "dataState")
    

}   //end func

//func readContext() {

//}

//func writeContext() {
    
//}


