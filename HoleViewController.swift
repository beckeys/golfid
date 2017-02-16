//
//  HoleViewController.swift
//  Golf-e Scorecard
//
//
//  Created by Scott Beckey on 4/20/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit

class HoleViewController: UIViewController {
    
    @IBOutlet weak var topLeftBox: UILabel!
    @IBOutlet weak var topRightBox: UILabel!
    @IBOutlet weak var image: UIButton!
    @IBOutlet weak var myNavBar: UINavigationBar!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    @IBAction func swipeInViewController(sender: UISwipeGestureRecognizer) {
        
        NSLog("Somebody swiped RIGHT!")
        previousHole()
        
    }
    @IBAction func swipeLeftInViewController(sender: AnyObject) {
        NSLog("Somebody swiped LEFT!")
        nextHole()
    }

    @IBAction func tap(sender: UIButton) {
        
        // the stroke button
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var scores: Array = defaults!.arrayForKey("rawScores")!
        var putts: Array = defaults!.arrayForKey("putts")!
        var parList: Array = defaults!.arrayForKey("holePar")!
        var hole:Int = defaults!.integerForKey("currentHole")
        var strokes:Int = scores[hole - 1] as! Int
        var lie = defaults!.stringForKey("currentLie")! // this gets current lie
        if lie == "Green" {                     // putts
            var t = putts[hole - 1] as! Int
            t++
            putts[hole - 1] = t
            defaults?.setObject(putts, forKey: "putts")
        }
        if ((strokes == 1) && (lie == "Fairway")) || ((strokes == 1) && (lie == "Green")) {    // fairways hit
            NSLog("Fairway Hit")
            var fairFlag: Array = defaults!.arrayForKey("fairFlag")!
            fairFlag[hole - 1] = true
            defaults?.setObject(fairFlag, forKey: "fairFlag")
        }
        var par:Int = parList[hole - 1] as! Int
        
        if ((strokes <= (par - 2)) && (lie == "Green")) { // greens in reg
            NSLog("Green in Reg")
            var girFlag: Array = defaults!.arrayForKey("girFlag")!
            girFlag[hole - 1] = true
            defaults?.setObject(girFlag, forKey: "girFlag")
        }
        
        strokes++
        scores[hole - 1] = strokes
        buttonText.setTitle("\(strokes)", forState: nil)
        leftButton.setTitle("Edit Lie", forState: nil)
        defaults!.setObject(scores, forKey: "rawScores")
        defaults?.synchronize()
        doRoundJournal()
        doUpdateHole()
        //**  play the stroke sound
        
    }
    
    @IBAction func leftButton(sender: AnyObject) {
        // the lie button
        var lie: String
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        lie = defaults!.stringForKey("currentLie")! // this gets current lie
        // case stmt***
        
        switch lie {
            case "Tee": lie = "Tee"   // can't change
            case "Fairway": lie = "Rough"  // most likely choice
            case "Rough": lie = "Bunker"
            case "Bunker": lie = "oob"
            case "oob": lie = "Penalty"
            case "Penalty": lie = "Green"
        default: lie = "Fairway"
        } //end switch
        
        defaults!.setObject(lie, forKey: "currentLie")
        doImageForLie(lie)
        leftButton.setTitle(lie, forState: nil)
    } //end func
    
    
    @IBAction func clubButton(sender: AnyObject) {
        // the club button
        rightButton.setTitle("Club Button", forState: nil)
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
    }   //end func ViewDidLoad
    
    override func viewDidAppear(animated: Bool) {
        
        //var nav = self.navigationController?.navigationBar
        myNavBar.barStyle = UIBarStyle.Black
        myNavBar.tintColor = UIColor.yellowColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "40Icon")
        imageView.image = image
        // myNavBar.image = imageView
        rightButton.setTitle("Club Button", forState: nil)
        leftButton.setTitle("Edit Lie", forState: nil)
        doUpdateHole()
    } //end func viewdidappear
    
    
    func nextHole(){
        // play ball in cup sound
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var hole:Int = defaults!.integerForKey("currentHole")
        var limit:Int = defaults!.integerForKey("holesInCurrentRound")
        if hole >= limit {
            self.performSegueWithIdentifier("SegueToRoundComplete", sender: nil)
            //set roundStopTimestamp
            //segue to the round summary
        }
        // set hole timestamp
        // future: write hole diary entry
        // future: set gps location hole diary
        hole++
        defaults!.setInteger(hole, forKey:"currentHole")
        doUpdateHole()
    } //end func nexthole
    
    func previousHole(){

        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        var hole:Int = defaults!.integerForKey("currentHole")
        var limit:Int = defaults!.integerForKey("holesInCurrentRound")
        // may want to check for locked state here
        // set hole timestamp
        // future: write hole diary entry
        // future: set gps location hole diary
        if hole > 1 {hole--} else {hole = 1 }
        defaults!.setInteger(hole, forKey:"currentHole")
        doUpdateHole()
    } //end func nexthole
    
    
    func doUpdateHole(){
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        let newLine = "\n"
        var theHoleNumber:Int = defaults!.integerForKey("currentHole")

        if theHoleNumber >= defaults?.integerForKey("holesInCurrentRound") {
            //we might be at hole 19 because the user didn't save
            //we'll let him either end the round or edit it
            theHoleNumber = defaults!.integerForKey("holesInCurrentRound")
        }
        var theHoleIndex: Int = theHoleNumber - 1

        //update the tapper button for the current Hole
        var scores: Array = defaults!.arrayForKey("rawScores")!
        var hole:Int = theHoleNumber
NSLog("**In hole controller with hole#\(theHoleNumber) \nrawScores:\(scores)")
        
        var strokes:Int = scores[hole - 1] as! Int
        buttonText.setTitle("\(strokes)", forState: nil)
        
        var parArray: Array = defaults!.arrayForKey("holePar")!
        var yardsArray: Array = defaults!.arrayForKey("holeYards")!
        
        var theHolePar: Int = parArray[theHoleIndex] as! Int
        var theHoleYards: Int = yardsArray[theHoleIndex] as! Int

        
        topLeftBox.text = defaults!.stringForKey("currentClub")! + newLine + defaults!.stringForKey("currentCourse")! + " Course" + newLine + defaults!.stringForKey("currentTee")!
        
        topRightBox.text = "Hole \(theHoleNumber)" + newLine + "Par \(theHolePar)" + newLine + "\(theHoleYards) Yards"
        
        doUpdateLie(theHolePar, strokes: strokes)
        
    } // end func doUpdateHole
    
    func doUpdateLie(par:Int, strokes:Int){
        NSLog("Update Lie for \(strokes) on Par \(par)")
        var lie: String
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        // lie = defaults!.stringForKey("currentLie") // this gets current lie
        lie = "Fairway"
        if strokes == 0 { lie = "Tee"}
        if strokes >= (par - 2) { lie = "Green"}
        defaults?.setObject(lie, forKey: "currentLie")
        
        doImageForLie( lie )
        // do the text for the left button (change lie)
    } //end func doUpdateLie
    
    
    func doImageForLie (lie:String){
        NSLog("Set Image for \(lie)")
        switch lie {
            case "Green":
                image.setBackgroundImage(UIImage(named: "green@1x.png"), forState: nil)
            case "Tee":
                image.setBackgroundImage(UIImage(named: "tee@1x.png"), forState: nil)
            case "Bunker":
                image.setBackgroundImage(UIImage(named: "bunker@1x.png"), forState: nil)
            case "oob":
                image.setBackgroundImage(UIImage(named: "oob@1x.png"), forState: nil)
            case "Penalty":
                image.setBackgroundImage(UIImage(named: "oob@1x.png"), forState: nil)  // same image
            case "Rough":
                image.setBackgroundImage(UIImage(named: "rough@1x.png"), forState: nil)
            case "Fairway":
                image.setBackgroundImage(UIImage(named: "fairway@1x.png"), forState: nil)
            default:
                image.setBackgroundImage(UIImage(named: "green@1x.png"), forState: nil)
        }   //end switch
        
    } //end func doImageforLie
    
} // end class