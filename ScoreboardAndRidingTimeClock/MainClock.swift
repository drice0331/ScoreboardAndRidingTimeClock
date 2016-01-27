//
//  MainClock.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 1/12/16.
//  Copyright © 2016 DrsCreations. All rights reserved.
//

import UIKit

class MainClock: BaseClock {

    static let MainTimeUpdatedNotification = "mainTimeUpdated"
    static let TimeUpdatedNotification = "timeUpdated"

    override init () {
        super.init()
    }
    
    func addOrSubtractTime( timeString : String, isTimeAdded : Bool) {
        
        var addedTimeValue : Double = 0.0
        
        //If adding seconds
        if((timeString as NSString).substringToIndex(1) == ":") {
            //let secondVal = (timeString as NSString).substringFromIndex(1)
            
            addedTimeValue = Double((timeString as NSString).substringFromIndex(1))!
        }
        //Else we're adding a minute
        else if((timeString as NSString).substringToIndex(1) == "1") {
            
            addedTimeValue = Double(1 * 60)
        }
        else {
            //TODO - shouldn't end up here, figure out how to throw exception of some sort
        }
        
        //check if down or up time button was pressed
        if(!isTimeAdded) {
            addedTimeValue = -addedTimeValue
        }
        
        self.elapsedTime = self.elapsedTime + addedTimeValue
        
        //last check - if below 0, then set to 0
        if(self.elapsedTime < 0) {
            self.elapsedTime = 0
        }
        
        self.timeUpdated()
    }
    
    func startTime() {
        let updateTime:Selector = "updateElapsedTime"
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(ClockTimeIncrement, target: self, selector: updateTime, userInfo: nil, repeats: true)
        self.clockRunning = true
    }

    func updateElapsedTime() {
        self.elapsedTime = self.elapsedTime - ClockTimeIncrement
        if(self.elapsedTime < 0) {
            self.elapsedTime = 0
        }
        NSLog("MainClock - \(self.elapsedTime)")
        self.timeUpdated()
    }
    
    override func timeString()->NSString {
        var resultTime : String = (super.timeString() as String)
        let minVal: String = (resultTime as NSString).substringToIndex(2)
        
        
        if((Int)(minVal as String) == 0) {

            //Get milliseconds string
            let milliseconds = abs(Int(((self.elapsedTime % 60) * 100) % 100))
            var millisecondsString = "00"
            if(milliseconds < 10) {
                millisecondsString = "0" + "\(milliseconds)"
            } else if(milliseconds >= 10) {
                millisecondsString = "\(milliseconds)"
            }

            //Combine
            resultTime =  resultTime + "." + millisecondsString
        }
        
        return resultTime
    }
    
    override func timeUpdated() {
        NSNotificationCenter .defaultCenter().postNotificationName(MainClock.TimeUpdatedNotification, object: nil)
    }
}
