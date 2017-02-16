//
//  SplashViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/17/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit
import Parse

class SplashViewController: UIViewController {
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    let vers:String = "Golf-e Scorecard V.095"
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }   //end func
    
    override func viewDidAppear(animated: Bool) {
        status.text = "New Game"
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults!.setValue("Ready", forKey: "dataState")
        
        doAnimation()
        doParse()
        doLocation()  // segues leave from here
    }
    
    func doParse () {
        //test Parse by writing a quick object
        var checkin = PFObject(className: "checkin")
        checkin.setObject(vers, forKey: "checkin")
        checkin.save()
        
        // now we test to see if the app has already logged in
        // var
        var currentUser = PFUser.currentUser()
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        doLogin()
        if currentUser != nil {
            NSLog("Current User is \(currentUser?.username).")
            //defaults!.setObject((currentUser?.username), forKey: "userName")
            //defaults!.setObject((currentUser?.username), forKey: "userID")
//            status.text = "Returning User \(currentUser?.username)\n\(vers)"
            status.text = "Returning User\n\(vers)"
        } else {
            //set them up as an anonymous user
            PFAnonymousUtils.logInWithBlock {
                (user, error) -> Void in
                if error != nil || user == nil {
                    NSLog("Anonymous login failed.")
                } else {
                    self.status.text = "Created New Anonymous user.\n To save rounds, set up a Profile."
                    initContext()
                    //defaults!.setObject("Anonymous", forKey: "userName")
                    //defaults!.setObject((currentUser?.username), forKey: "userID")
                    defaults!.setObject("ClubSelect", forKey: "appState")
                    //currentUser["firstName"] = "NoNameYet"
                    //currentUser["lastName"] = "NoFirstNameYet"
                    //currentUser["GHIN"] = "0"

                }   //endif
            }   //end block
         }   //endif
        defaults?.synchronize()

    } //end func
    
    func doLocation() {
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (myLoc, error) -> Void in
            if error == nil {
                // NSLog("Location returned \(myLoc)")
                let userLat = myLoc!.latitude as Double
                let userLon = myLoc!.longitude as Double
                //add location to NSUserDefaults
                var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
                defaults!.setObject(userLat, forKey: "latitude")
                defaults!.setObject(userLon, forKey: "longitude")
                NSLog("Got Location: \(userLat) \(userLon).")
            } else {
                NSLog("We got an error trying to get the users location: \(error)")
            } //endif
            
            
            //segue to hole controller if there's a game in progress
            NSLog("IN Do Parse about to segue out of Splash based on AppState")
            
            var appState = defaults?.stringForKey("appState")
            if appState == nil { appState = "ClubSelect" }
            switch appState! {    //ClubSelect, CourseSelect, TeeSelect, RoundInProgress
                case "ClubSelect":
                    self.performSegueWithIdentifier("segueToNearby", sender: nil)
                case "CourseSelect":
                    self.performSegueWithIdentifier("segueToCourse", sender: nil)
                case "TeeSelect":
                    self.performSegueWithIdentifier("segueToTee", sender: nil)
                case "RoundInProgress":
                    self.performSegueWithIdentifier("SegueGameInProgress", sender: nil)
                default:
                    defaults!.setObject("ClubSelect", forKey: "appState") // didn't get initialized?
                    self.performSegueWithIdentifier("segueToNearby", sender: nil)
            } // end switch
            
        }   //end block
    }   //end func

    
    func doAnimation() {
        var imgListArray :NSMutableArray = []
        for position in 1...128 {
            var strImageName : String = "splash\(position)"
            var image  = UIImage(named:strImageName)
            imgListArray.addObject(image!)
        }   //end for loop
        splashImage.animationImages = imgListArray as [AnyObject];
        splashImage.animationDuration = 6
        splashImage.animationRepeatCount = 1
        splashImage.startAnimating()
    }  // end func doanimation
    
    func doLogin(){
        // we may or may not be logged in according to Parse.
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")

        let myName = defaults!.stringForKey("userName")
        let myPass = defaults!.stringForKey("userPwd")
        
        PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                NSLog("doLOGIN Success")
            } else {
                NSLog("doLOGIN Error: \(error)")
            }
        }
    }

}   //end class

