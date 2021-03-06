//
//  MainScoreboardViewController.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 1/30/16.
//  Copyright © 2016 DrsCreations. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MainScoreboardViewController: BaseViewController {

    //Views
    //TODO - manually resize based on screen dimens
    
    @IBOutlet var timeLabel: UILabel!
    
    //timer/clock buttons
    @IBOutlet var oneMinUp: UIButton!
    @IBOutlet var oneMinDown: UIButton!
    @IBOutlet var thirtySecUp: UIButton!
    @IBOutlet var thirtySecDown: UIButton!
    @IBOutlet var tenSecUp: UIButton!
    @IBOutlet var tenSecDown: UIButton!
    @IBOutlet var oneSecUp: UIButton!
    @IBOutlet var oneSecDown: UIButton!
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    //Score labels
    @IBOutlet var redScoreLabel: UILabel!
    @IBOutlet var greenScoreLabel: UILabel!
    
    //Red score buttons
    @IBOutlet var decrementRedButton: UIButton!
    @IBOutlet var incrementRedButton: UIButton!
    @IBOutlet var takedown2RedButton: UIButton!
    @IBOutlet var penalty1RedButton: UIButton!
    @IBOutlet var nearfall2RedButton: UIButton!
    @IBOutlet var nearfall3RedButton: UIButton!
    @IBOutlet var nearfall4RedButton: UIButton!
    @IBOutlet var escape1RedButton: UIButton!
    @IBOutlet var reversal2RedButton: UIButton!
    
    //Green score buttons
    @IBOutlet var decrementGreenButton: UIButton!
    @IBOutlet var incrementGreenButton: UIButton!
    @IBOutlet var takedown2GreenButton: UIButton!
    @IBOutlet var penalty1GreenButton: UIButton!
    @IBOutlet var nearfall2GreenButton: UIButton!
    @IBOutlet var nearfall3GreenButton: UIButton!
    @IBOutlet var nearfall4GreenButton: UIButton!
    @IBOutlet var escape1GreenButton: UIButton!
    @IBOutlet var reversal2GreenButton: UIButton!
    
    var clock:MainClock = MainClock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeselector : Selector = "timeUpdated:"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: timeselector, name:  MainClock.TimeUpdatedNotification, object:nil)
        
        self.clock = MainClock.init()
        self.clock.reset()
        
    }
    
    func timeUpdated(notification:NSNotification) {
        
        let clocktime : String = self.clock.timeString() as String
        if self.clock.getElapsedTime() <= 0 {
            self.clock.stop()
            self.playBuzzer("")
        }
        self.timeLabel.text = clocktime
    }
    
    //
    //Main clock actions
    //
    @IBAction func startStopMainClock(sender: AnyObject) {
        //if main clock is running, then both that, as well as riding time clock should stop
        if self.clock.clockRunning {
            self.clock.stop()
        } else {
            if clock.elapsedTime > 0 {
                self.clock.startTime()
            }
        }
    }
    
    @IBAction func resetMainClock(sender: AnyObject) {
        self.clock.reset()
    }
    
    @IBAction func changeMainTimer(sender: AnyObject) {
        
        if sender .isKindOfClass(UIButton) {
            
            let button : UIButton = (sender as! UIButton)
            let tagValue = Bool(button.tag)
            let timeValue = button.titleLabel!.text
            self.clock.addOrSubtractTime(timeValue!, isTimeAdded: tagValue)
        }
        
    }
    
    @IBAction func changeScore(sender: AnyObject) {
        
        if sender .isKindOfClass(UIButton) {
            
            let button : UIButton = (sender as! UIButton)
            let whichScoreLabel = button.tag
            let scoreType = button.titleLabel!.text
            let endIndex = (scoreType! as String).endIndex.advancedBy(-1)
            var addedScore : Int = 0
            
            //Determine addedscore
            if scoreType != "+" && scoreType != "-" {
                //if not incrementer, then get last char of text from button
                addedScore = Int((scoreType! as String).substringFromIndex(endIndex))!
            } else {
                //if incrementer, then 1 or -1 for addedscore
                if scoreType == "+" {
                    addedScore = 1
                } else if scoreType == "-" {
                    addedScore = -1
                }
            }
            
            //determine which score label to add to
            if whichScoreLabel == 0 {
                var curRedScore = Int(self.redScoreLabel.text as String!)
                curRedScore = curRedScore! + addedScore
                if curRedScore < 0 {
                    curRedScore = 0
                }
                self.redScoreLabel.text = "\(curRedScore!)"
            } else if whichScoreLabel == 1 {
                var curGreenScore = Int(self.greenScoreLabel.text as String!)
                curGreenScore = curGreenScore! + addedScore
                if curGreenScore < 0 {
                    curGreenScore = 0
                }
                self.greenScoreLabel.text = "\(curGreenScore!)"
            }
            
        }
    }
    
}