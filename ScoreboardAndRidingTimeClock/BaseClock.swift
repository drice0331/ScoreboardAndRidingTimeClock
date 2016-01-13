//
//  BaseClock.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 1/12/16.
//  Copyright © 2016 DrsCreations. All rights reserved.
//

import UIKit

class BaseClock: NSObject {

    static let TimeUpdatedNotification = "timeUpdated"
    
    let ClockTimeIncrement = 0.02
    
    var clockRunning = Bool()
    //var isRed = Bool()
    //var isGreen = Bool()
    
    var elapsedTime = NSTimeInterval()
    var dateFormatter = NSDateFormatter()
    var timer:NSTimer = NSTimer()
    
    override init () {
        super.init()
        
        self.clockRunning = false
        //self.isGreen = false
        //self.isRed = false
        
        self.dateFormatter = NSDateFormatter.init()
        self.dateFormatter.dateFormat = "mm:ss.SS"
    }
    
    func stop() {
        self.timer .invalidate()
        self.clockRunning = false
        //self.isGreen = false
        //self.isRed = false
    }
    
    func reset() {
        self.stop()
        self.elapsedTime = 0.0
        self.timeUpdated()
    }
    
    func timeString()->NSString {
        //let date = NSDate(timeIntervalSince1970: abs(self.elapsedTime))
        //let timeResultString = self.dateFormatter.stringFromDate(date)
        
        
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
        let resultTime = minuteString + ":" + secondString + "." + millisecondsString
        
        return  resultTime
    }
    
    func getElapsedTime()->Double {
        return self.elapsedTime
    }
    
    func timeUpdated() {
        NSNotificationCenter .defaultCenter().postNotificationName(BaseClock.TimeUpdatedNotification, object: nil)
    }

}
