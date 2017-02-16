//
//  RoundCompleteViewController.swift
//  Golf-e Scorecard
//
//  Created by Scott Beckey on 4/29/15.
//  Copyright (c) 2015 GolfID. All rights reserved.
//

import UIKit


class RoundCompleteViewController: UIViewController {
    @IBOutlet weak var rawScore: UILabel!
    @IBOutlet weak var parTotal: UILabel!
    @IBOutlet weak var fairways: UILabel!
    @IBOutlet weak var greens: UILabel!
    @IBOutlet weak var totalHoles: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear(animated: Bool) {
    
    var count = 0
    
    var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
    let rip = defaults!.boolForKey("roundInProgress")
    let holes = defaults!.integerForKey("holesInCurrentRound")
    let starttime = defaults!.stringForKey("roundStartTimestamp")
    let stoptime = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
    var rawScores: Array = defaults!.arrayForKey("rawScores")!
    var girScores: Array = defaults!.arrayForKey("girFlag")!
    var fairScores: Array = defaults!.arrayForKey("fairFlag")!
    var holePar: Array = defaults!.arrayForKey("holePar")!
        
    var fairCount = 0
    var totalScore: Int = 0
    var girCount:Int = 0
    var holesPlayed:Int = 0
    var totalPar:Int = 0
    var label1Text = ""
    var label2Text = ""
    
        //put stoptime back in defaults
    defaults!.setObject(stoptime, forKey: "roundStopTimestamp")
    defaults!.setBool(false, forKey: "roundInProgress")
        defaults?.setValue("RoundComplete", forKey: "appState")
    
    for count in 1...holes {
        totalScore = rawScores[count - 1] as! Int + totalScore
        if rawScores[count - 1] as! Int > 0 {
            holesPlayed++
        totalPar += holePar[ count - 1 ] as! Int}
            if girScores[count - 1] as! Bool == true { girCount++ }
        if fairScores[count - 1] as! Bool == true { fairCount++ }
        } //end for
    
    rawScore.text = "\(totalScore)"
    parTotal.text = "\(totalPar)"
    fairways.text = "\(fairCount)"
    greens.text = "\(girCount)"
    totalHoles.text = "\(holesPlayed) holes played of \(holes)\n\(starttime!) Start\n\(stoptime) End"
        
        var gameSummaryString = starttime! + " \(holesPlayed) holes. Score \(totalScore) par \(totalPar)"
        // might also want course and tees here, if it fits
        defaults!.setObject(gameSummaryString, forKey: "roundSummaryString")
        defaults?.synchronize()
        
    }
    
    @IBOutlet weak var saveButtonInToolbar: UIToolbar!
    @IBAction func saveButton(sender: AnyObject) {
        var defaults = NSUserDefaults(suiteName: "group.com.golfid.appgroup")
        defaults?.setValue("SaveRound", forKey: "appState")
        
        doSaveScorecard()
        defaults?.setValue("ClubSelect", forKey: "appState")
        
        self.performSegueWithIdentifier("SegueToBeginning", sender: nil)
        
    }
}
