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
    
    
    var clock:Clock = Clock()
    
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

        let selector : Selector = "timeUpdated:"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name:  Clock.TimeUpdatedNotification, object:nil)
        
        self.clock = Clock.init()
        self.clock.reset()
        
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
        if self.clock.clockRunning {
            self.clock.stop()
        }
    }
    
    @IBAction func resetButtonClick(sender: AnyObject) {
        
        self.clock.reset()
    }
    
    func timeUpdated(notification:NSNotification) {
        self.timeLabel.text = self.clock.timeString() as String
        
        if self.clock.getElapsedTime() < 0 {
            
            self.timeLabel.textColor = UIColor.redColor()
            
        } else if self.clock.getElapsedTime() > 0 {
            
            self.timeLabel.textColor = UIColor.greenColor()
            
        } else {
            
            self.timeLabel.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func startStopMainClock(sender: AnyObject) {
    }
    func getTimeString() -> String {
        let date = NSDate(timeIntervalSince1970: self.elapsedTime)
        return self.dateFormatter .stringFromDate(date)
    }
    
    @IBAction func changeMainTimer(sender: AnyObject) {
        
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
