//
//  LoginViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/29/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

// This VC is supposed to do both LOGIN and PROFILE (update login information)
//

import Foundation
import Parse



class LoginViewController : UIViewController/*, PFLogInViewControllerDelegate*/ {

    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var formName: UITextField!
    @IBOutlet weak var formPassword: UITextField!
    @IBOutlet weak var formEmail: UITextField!
    @IBOutlet weak var formGHIN: UITextField!
    @IBOutlet weak var formEmailSwitch: UISwitch!
    @IBOutlet weak var formPostRoundSwitch: UISwitch!
    @IBOutlet weak var doneButtonText: UIBarButtonItem!
    
    @IBAction func doneButton(sender: AnyObject) {
        
        if doGoodnessChecks() == true {
            doSignUp()
        }
        self.performSegueWithIdentifier("SegueProfileToNearby", sender: nil)
    } // end done button
   

    var user = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("In View Did Load of Login controller")
        bigLabel.text = "Current UserName \(user.username) Linked Status \(PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser()))"
        
    }   //end func ViewDidLoad
    
    override func viewDidAppear(animated: Bool) {
        
        NSLog("IN PROFILE")
        //are we logged in?
        doneButtonText.title = "DONE"
        
        if PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser()) {
            NSLog("We have a linked current User")
           // so in this case we are an UPDATE service
        } else {
            // or in this case we are a NEW USER Signup
            NSLog("We don't have a linked current user")
        } //endif
        
        //get current info and put it on the view controller
        
        if user.username != nil { formName.text = user.username}
        // prefill what we know

        if user["name"] != nil { formName.text = user["firstName"] as? String }
        if user.password != nil { formPassword.text = user.password }
        if user.email != nil { formEmail.text = user.email }
        if user["GHIN"] != nil { formGHIN.text = user["GHIN"] as? String }
    } // end viewDidAppear
    
    func doGoodnessChecks() -> Bool {
        NSLog("Goodness checks: userName: \(formName.text)")
        
        if formName.text == nil { complain("Empty Name Field")
            return false }
        if count(formPassword.text) < 5 { complain("Password must be greater than 5 characters")
            return false }
        if count(formName.text) < 3 {complain("First Name Required")
            return false }
//test email address here too
        
        // more here
        
        return true
    }
    
    
    func complain( complaint : String ) {
        let alertController = UIAlertController(title: "Sorry", message: complaint, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }

    func doSignUp() {
        
        NSLog("In Signup.")
        var user = PFUser()
        user.username = formName.text
        user.password = formPassword.text
        user.email = formEmail.text
        user["GHIN"] = formGHIN.text
        user["emailPermission"] = formEmailSwitch.on
        user["postRequest"] = formPostRoundSwitch.on
        
        user.signUpInBackgroundWithBlock {
            (success, error) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                NSLog("\(errorString)")
                // user should get to try again here.

            } else {
                // Hooray! Let them use the app now.
                //save the username and password for autologin in the future
                var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
                defaults!.setObject(self.formName.text, forKey: "userName")
                defaults!.setObject(self.formPassword.text, forKey: "userPwd")
                defaults!.setObject(self.formEmail.text, forKey: "userEmail")
                defaults!.setObject(self.formEmailSwitch, forKey: "userOptIn")
                defaults?.synchronize()
            }
        }
    }
    
} //end class


