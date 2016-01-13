//
//  Clock.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 12/31/15.
//  Copyright © 2015 DrsCreations. All rights reserved.
//

import UIKit

class Clock: NSObject {

    static let TimeUpdatedNotification = "timeUpdated"
    
    let ClockTimeIncrement = 0.02
    
    var clockRunning = Bool()
    var isRed = Bool()
    var isGreen = Bool()
    
    var elapsedTime = NSTimeInterval()
    var dateFormatter = NSDateFormatter()
    var timer:NSTimer = NSTimer()
    
    override init () {
        super.init()
        
        self.clockRunning = false
        self.isGreen = false
        self.isRed = false
        
        self.dateFormatter = NSDateFormatter.init()
        self.dateFormatter.dateFormat = "mm:ss.SS"
    }
    
    func greenTime() {
        
        let greenTime:Selector = "updateElapsedTimeGreen"
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(ClockTimeIncrement, target: self, selector: greenTime, userInfo: nil, repeats: true)
        self.clockRunning = true
        self.isGreen = true
        self.isRed = false
        //self.timeUpdated()
    }
    
    func redTime() {
        
        let redTimeSel:Selector = "updateElapsedTimeRed"
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(ClockTimeIncrement, target: self, selector: redTimeSel, userInfo: nil, repeats: true)
        self.clockRunning = true
        self.isGreen = false
        self.isRed = true
        //self.timeUpdated()
    }
    
    func stop() {
        self.timer .invalidate()
        self.clockRunning = false
        self.isGreen = false
        self.isRed = false
        //timeupdate
    }
    
    func reset() {
        self.stop()
        self.elapsedTime = 0.0
        self.timeUpdated()
    }
    
    func timeString()->NSString {
        let date = NSDate(timeIntervalSince1970: abs(self.elapsedTime))
        let timeResultString = self.dateFormatter.stringFromDate(date)
        
        
        //Get minute string
        var minuteString = "00"
        let minutes = abs(Int(self.elapsedTime / 60 ))
        if(minutes < 10) {
            minuteString = "0" + "\(minutes)"
        } else if(minutes >= 10) {
            minuteString = "\(minutes)"
        }
        
        //Get seconds string
        var secondString = "00"
        let seconds = abs(Int(self.elapsedTime % 60))
        if(seconds < 10) {
            secondString = "0" + "\(seconds)"
        } else if(seconds >= 10) {
            secondString = "\(seconds)"
        }

        //Get milliseconds string
        let milliseconds = abs(Int(((self.elapsedTime % 60) * 100) % 100))
        //var millisecondsString = "\(milliseconds)" + "0"
        var millisecondsString = "00"
        if(milliseconds < 10) {
            millisecondsString = "0" + "\(milliseconds)"
        } else if(milliseconds >= 10) {
            millisecondsString = "\(milliseconds)"
        }
        
        //Combine
        var resultTime = minuteString + ":" + secondString + "." + millisecondsString
        
        return  resultTime
    }
    
    func getElapsedTime()->Double {
        return self.elapsedTime
    }
    
    func updateElapsedTimeGreen() {
        self.elapsedTime = self.elapsedTime + ClockTimeIncrement
        NSLog("green - \(self.elapsedTime)")
        self.timeUpdated()
    }
    
    func updateElapsedTimeRed() {
        self.elapsedTime = self.elapsedTime - ClockTimeIncrement
        NSLog("red - \(self.elapsedTime)")
        self.timeUpdated()
    }
    
    func timeUpdated() {
        NSNotificationCenter .defaultCenter().postNotificationName(Clock.TimeUpdatedNotification, object: nil)
    }
    
}
