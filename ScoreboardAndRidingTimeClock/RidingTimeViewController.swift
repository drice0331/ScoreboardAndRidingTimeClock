//
//  RidingTimeViewController.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 1/27/16.
//  Copyright © 2016 DrsCreations. All rights reserved.
//

import Foundation
import UIKit
import BTNavigationDropdownMenu

class RidingTimeViewController: BaseViewController {

    //Views
    //TODO - manually resize based on screen dimens
    @IBOutlet var ridingTimeLabel: UILabel!

    @IBOutlet var redTimeButton: UIButton!
    @IBOutlet var greenTimeButton: UIButton!
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    var ridingTimeClock:RidingTimeClock = RidingTimeClock()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ridingtimeselector : Selector = "timeUpdated:"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ridingtimeselector, name:  RidingTimeClock.TimeUpdatedNotification, object:nil)
        
        self.ridingTimeClock = RidingTimeClock.init()
        self.ridingTimeClock.reset()
        
    }
    
    @IBAction func redButtonClick(sender: AnyObject) {
        if !self.ridingTimeClock.clockRunning {
            self.ridingTimeClock.redTime()
        } else if(self.ridingTimeClock.isGreen) {
            self.ridingTimeClock.stop()
            self.ridingTimeClock.redTime()
        }
    }
    @IBAction func greenButtonClick(sender: AnyObject) {
        if !self.ridingTimeClock.clockRunning {
            self.ridingTimeClock.greenTime()
        } else if(self.ridingTimeClock.isRed) {
            self.ridingTimeClock.stop()
            self.ridingTimeClock.greenTime()
        }
    }
    
    @IBAction func stopButtonClick(sender: AnyObject)
    {
        self.ridingTimeClock.stop()
        self.updateRedGreenTimeButton()
    }
    
    @IBAction func resetButtonClick(sender: AnyObject)
    {        
        self.ridingTimeClock.reset()
    }

    func timeUpdated(notification:NSNotification) {
        
        //Set RidingTime Label
        self.updateRidingTimeLabel()
        
        //Set Red or Green button labels
        self.updateRedGreenTimeButton()
        
    }
    
    func updateRedGreenTimeButton() {
        
        //Set Red or Green button highlighted label
        if self.ridingTimeClock.isGreen {
            self.greenTimeButton.titleLabel?.backgroundColor = UIColor.greenColor()
            self.greenTimeButton.titleLabel?.textColor = UIColor.whiteColor()
            
            self.redTimeButton.titleLabel?.backgroundColor = UIColor.whiteColor()
            self.redTimeButton.titleLabel?.textColor = UIColor.redColor()
            
        } else if self.ridingTimeClock.isRed {
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
    
}