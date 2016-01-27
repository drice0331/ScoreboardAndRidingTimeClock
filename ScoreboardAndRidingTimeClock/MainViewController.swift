//
//  MainViewController.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 12/30/15.
//  Copyright © 2015 DrsCreations. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //Views
    @IBOutlet var mainTimeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var mainClockStartStopButton: UIButton!
    
    @IBOutlet var oneMinUp: UIButton!
    @IBOutlet var oneMinDown: UIButton!
    @IBOutlet var thirtySecUp: UIButton!
    @IBOutlet var thirtySecDown: UIButton!
    @IBOutlet var tenSecUp: UIButton!
    @IBOutlet var tenSecDown: UIButton!
    @IBOutlet var oneSecUp: UIButton!
    @IBOutlet var oneSecDown: UIButton!
    
    @IBOutlet var redTimeButton: UIButton!
    @IBOutlet var greenTimeButton: UIButton!
    
    @IBOutlet var redScoreLabel: UILabel!
    @IBOutlet var greenScoreLabel: UILabel!
    
    
    var clock:Clock = Clock()
    var mainclock:MainClock = MainClock()
    
    var clockRunning = Bool()
    var isRed = Bool()
    var isGreen = Bool()
    
    var startTime = NSTimeInterval()
    
    var elapsedTime = NSTimeInterval()
    var dateFormatter = NSDateFormatter()
    var timer:NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clockRunning = false
        isGreen = false
        isRed = false
        
        dateFormatter.dateFormat = "mm:ss.SS"

        let ridingtimeselector : Selector = "timeUpdated:"
        let maintimeselector : Selector = "mainTimeUpdated"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ridingtimeselector, name:  Clock.TimeUpdatedNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ridingtimeselector, name: MainClock.MainTimeUpdatedNotification, object: nil)
        
        self.clock = Clock.init()
        self.clock.reset()
        
        self.mainclock = MainClock.init()
        self.mainclock.reset()
        
    }

    @IBAction func redButtonClick(sender: AnyObject) {
        if !self.clock.clockRunning {
            self.clock.redTime()
        } else if(self.clock.isGreen) {
            self.clock.stop()
            self.clock.redTime()
        }
        /*
            let redSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: redSelector, userInfo: nil, repeats: true)
            self.clockRunning = true
            self.isGreen = false
            self.isRed = true
        */
    }
    @IBAction func greenButtonClick(sender: AnyObject) {
        if !self.clock.clockRunning {
            self.clock.greenTime()
        } else if(self.clock.isRed) {
            self.clock.stop()
            self.clock.greenTime()
        }
        /*
            let greenSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: greenSelector, userInfo: nil, repeats: true)
            self.clockRunning = true
            self.isGreen = true
            self.isRed = false
        */
    }
    
    @IBAction func stopButtonClick(sender: AnyObject)
    {
        //if self.clock.clockRunning {
        self.clock.stop()
        self.updateRedGreenTimeButton()
        //}
    }
    
    @IBAction func resetButtonClick(sender: AnyObject) {
        
        self.clock.reset()
    }
    
    func timeUpdated(notification:NSNotification) {

        //Set Main Time Label
        self.updateMainClockTimeLabel()
        
        //Set RidingTime Label
        self.updateRidingTimeLabel()
        
        //Set Red or Green button labels
        self.updateRedGreenTimeButton()
        
    }
    
    func updateMainClockTimeLabel() {

        let mainclocktime : String = self.mainclock.timeString() as String
        if self.mainclock.getElapsedTime() <= 0 {
            self.mainclock.stop()
            self.clock.stop()
        }
        self.mainTimeLabel.text = mainclocktime
    }
    
    func updateRidingTimeLabel() {
        
        self.timeLabel.text = self.clock.timeString() as String
        
        //Set RidingTime Label color
        if self.clock.getElapsedTime() < 0 {
            
            self.timeLabel.textColor = UIColor.redColor()
            
        } else if self.clock.getElapsedTime() > 0 {
            
            self.timeLabel.textColor = UIColor.greenColor()
            
        } else {
            self.timeLabel.textColor = UIColor.blackColor()
        }
    }
    
    func updateRedGreenTimeButton() {
        
        //Set Red or Green button highlighted label
        if self.clock.isGreen {
            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.greenColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.whiteColor()
            
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.redColor()
            
        } else if self.clock.isRed {
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.redColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.whiteColor()
            
            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.greenColor()
            
        } else {
            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.greenColor()
            
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.redColor()
        }
    }
    
    func mainTimeUpdated(notification:NSNotification) {
        let mainclocktime : String = self.mainclock.timeString() as String
        
        if self.mainclock.getElapsedTime() <= 0 {
            self.mainclock.stop()
        } else {
            self.mainTimeLabel.text = mainclocktime
        }
        
        
    }
    
    //
    //Main clock actions
    //
    @IBAction func startStopMainClock(sender: AnyObject) {
        //if main clock is running, then both that, as well as riding time clock should stop
        if self.mainclock.clockRunning {
            self.mainclock.stop()
            if self.clock.clockRunning {
                //Using different stop method for riding time clock if still running, to
                //preserve riding time state
                self.clock.mainTimeStop()
            }
        } else {
            if mainclock.elapsedTime > 0 {
                self.mainclock.startTime()
                
                //If riding time clock is not running then run
                //riding time clock if green or red time still on
                if !self.clock.clockRunning {
                    if self.clock.isGreen {
                        self.clock.greenTime()
                    } else if self.clock.isRed {
                        self.clock.redTime()
                    }
                }
                
            }
        }
    }
    
    @IBAction func resetMainClock(sender: AnyObject) {
        self.mainclock.reset()
    }
    
    @IBAction func changeMainTimer(sender: AnyObject) {
        
        if sender .isKindOfClass(UIButton) {
            
            let button : UIButton = (sender as! UIButton)
            let tagValue = Bool(button.tag)
            let timeValue = button.titleLabel!.text
            self.mainclock.addOrSubtractTime(timeValue!, isTimeAdded: tagValue)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func getTimeString() -> String {
        let date = NSDate(timeIntervalSince1970: self.elapsedTime)
        return self.dateFormatter .stringFromDate(date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
