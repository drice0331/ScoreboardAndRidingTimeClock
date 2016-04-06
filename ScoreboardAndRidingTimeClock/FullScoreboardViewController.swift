//
//  FullScoreboardViewController.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 12/30/15.
//  Copyright © 2015 DrsCreations. All rights reserved.
//

import UIKit

class FullScoreboardViewController: BTPeripheralViewController {

    //Views - 
    //TODO - manually resize based on screen dimens and device
    //Time labels
    @IBOutlet var mainTimeLabel: UILabel!
    @IBOutlet var ridingTimeLabel: UILabel!
    
    //Score Labels
    @IBOutlet var redScoreLabel: UILabel!
    @IBOutlet var greenScoreLabel: UILabel!
    
    //Note - all buttons are only here so they can manually be resized later,
    //and have no other use as outlets

    //Main time buttons
    @IBOutlet var oneMinUp: UIButton!
    @IBOutlet var oneMinDown: UIButton!
    @IBOutlet var thirtySecUp: UIButton!
    @IBOutlet var thirtySecDown: UIButton!
    @IBOutlet var tenSecUp: UIButton!
    @IBOutlet var tenSecDown: UIButton!
    @IBOutlet var oneSecUp: UIButton!
    @IBOutlet var oneSecDown: UIButton!
    @IBOutlet var mainClockStartStopButton: UIButton!
    @IBOutlet var mainTimeResetButton: UIButton!

    //Riding time buttons
    @IBOutlet var redTimeButton: UIButton!
    @IBOutlet var greenTimeButton: UIButton!
    @IBOutlet var ridingTimeResetButton: UIButton!
    @IBOutlet var ridingTimeNeutralButton: UIButton!

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
    
    var ridingTimeClock:RidingTimeClock = RidingTimeClock()
    var mainclock:MainClock = MainClock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ridingtimeupdateselector : Selector = "ridingTimeUpdated:"
        let maintimeupdateselector : Selector = "mainTimeUpdated:"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ridingtimeupdateselector, name:  RidingTimeClock.TimeUpdatedNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: maintimeupdateselector, name: MainClock.TimeUpdatedNotification, object: nil)
        
        self.ridingTimeClock = RidingTimeClock.init()
        self.ridingTimeClock.reset()
        
        self.mainclock = MainClock.init()
        self.mainclock.reset()
        
    }

    @IBAction func redTimeClick(sender: AnyObject) {
        if self.mainclock.clockRunning {
            if !self.ridingTimeClock.clockRunning {
                self.ridingTimeClock.redTime()
            } else if(self.ridingTimeClock.isGreen) {
                self.ridingTimeClock.stop()
                self.ridingTimeClock.redTime()
            }
        } else {
            self.ridingTimeClock.isGreen = false;
            self.ridingTimeClock.isRed = true;
            self.updateRidingTimeButtonColors();
        }
    }
    
    @IBAction func greenTimeClick(sender: AnyObject) {
        if self.mainclock.clockRunning {
            if !self.ridingTimeClock.clockRunning {
                self.ridingTimeClock.greenTime()
            } else if(self.ridingTimeClock.isRed) {
                self.ridingTimeClock.stop()
                self.ridingTimeClock.greenTime()
            }
        } else {
            self.ridingTimeClock.isGreen = true;
            self.ridingTimeClock.isRed = false;
            self.updateRidingTimeButtonColors();
        }
    }
    
    @IBAction func ridingTimeNeutralClick(sender: AnyObject)
    {
        self.ridingTimeClock.stop()
        self.updateRidingTimeButtonColors()
    }
    
    @IBAction func ridingTimeResetClick(sender: AnyObject) {
        
        self.ridingTimeClock.reset()
    }
    
    /**
    * Main clock update notification method
    **/
    func mainTimeUpdated(notification:NSNotification) {

        //Set Main Time Label
        self.updateMainClockTimeLabel()
        
        //Set Red or Green button labels
        self.updateRidingTimeButtonColors()
        
    }

    /**
     * Riding time clock update notification method
     **/
    func ridingTimeUpdated(notification:NSNotification) {
        
        //Set RidingTime Label
        self.updateRidingTimeLabel()
        
        //Set Red or Green button labels
        self.updateRidingTimeButtonColors()
        
    }
    
    func updateMainClockTimeLabel() {

        let mainclocktime : String = self.mainclock.timeString() as String
        if self.mainclock.getElapsedTime() <= 0 {
            if mainclock.clockRunning {
                
                self.playBuzzer("")
            }
            self.mainclock.stop()
            self.ridingTimeClock.stop()
        }
        self.mainTimeLabel.text = mainclocktime
    }
    
    func updateRidingTimeLabel() {
        
        self.ridingTimeLabel.text = self.ridingTimeClock.timeString() as String
        
        //Set RidingTime Label color
        if self.ridingTimeClock.getElapsedTime() < 0 {
            
            self.ridingTimeLabel.textColor = UIColor.redColor()
            
        } else if self.ridingTimeClock.getElapsedTime() > 0 {
            
            self.ridingTimeLabel.textColor = UIColor.greenColor()
            
        } else {
            self.ridingTimeLabel.textColor = UIColor.blackColor()
        }
    }
    
    /**
    * Set Red, Green, and Neutral button to correct label colors
    **/
    func updateRidingTimeButtonColors() {
        
        //Set Red or Green button highlighted label
        
        if self.ridingTimeClock.isGreen {
            self.greenTimeButton.titleLabel!.backgroundColor = UIColor.greenColor()
            self.greenTimeButton.titleLabel!.textColor = UIColor.whiteColor()
            
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.redColor()

            self.ridingTimeNeutralButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.ridingTimeNeutralButton.titleLabel?.textColor = UIColor.blackColor()

        } else if self.ridingTimeClock.isRed {
            self.redTimeButton.titleLabel!.backgroundColor = UIColor.redColor()
            self.redTimeButton.titleLabel!.textColor = UIColor.whiteColor()

            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.greenColor()
            
            self.ridingTimeNeutralButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.ridingTimeNeutralButton.titleLabel?.textColor = UIColor.blackColor()
        } else {//we're in neutral
            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.greenColor()
            
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.redColor()
            
            if(self.mainclock.getElapsedTime() > 0) {
                self.ridingTimeNeutralButton.titleLabel!.backgroundColor = UIColor.blackColor()
                self.ridingTimeNeutralButton.titleLabel!.textColor = UIColor.whiteColor()
            } else {
                self.ridingTimeNeutralButton.titleLabel?.backgroundColor = UIColor.whiteColor()
                self.ridingTimeNeutralButton.titleLabel?.textColor = UIColor.blackColor()
            }
            
        }
    }
    
    //
    //Main clock actions
    //
    @IBAction func startStopMainClock(sender: AnyObject) {
        //if main clock is running, then both that, as well as riding time clock should stop
        if self.mainclock.clockRunning {
            self.mainclock.stop()
            if self.ridingTimeClock.clockRunning {
                //Using different stop method for riding time clock if still running, to
                //preserve riding time state
                self.ridingTimeClock.mainTimeStop()
            }
        } else {
            if mainclock.elapsedTime > 0 {
                self.mainclock.startTime()
                
                //If riding time clock is not running then run
                //riding time clock if green or red time still on
                if !self.ridingTimeClock.clockRunning {
                    if self.ridingTimeClock.isGreen {
                        self.ridingTimeClock.greenTime()
                    } else if self.ridingTimeClock.isRed {
                        self.ridingTimeClock.redTime()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
