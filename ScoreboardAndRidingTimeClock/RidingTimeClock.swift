//
//  Clock.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 12/31/15.
//  Copyright © 2015 DrsCreations. All rights reserved.
//

import UIKit

class RidingTimeClock: BaseClock {

    static let TimeUpdatedNotification = "timeUpdated"
    
    
    var isRed = Bool()
    var isGreen = Bool()
    
    
    override init () {
        super.init()
        
        self.isGreen = false
        self.isRed = false
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
    
    override func stop() {
        super.stop()
        self.isGreen = false
        self.isRed = false
    }
    
    func mainTimeStop() {
        super.stop()
    }
    
    override func timeString()->NSString {
        var resultTime = (super.timeString() as String)
        
        //Get milliseconds string
        let milliseconds = abs(Int(((self.elapsedTime % 60) * 100) % 100))
        var millisecondsString = "00"
        if(milliseconds < 10) {
            millisecondsString = "0" + "\(milliseconds)"
        } else if(milliseconds >= 10) {
            millisecondsString = "\(milliseconds)"
        }
        
        //Combine
        resultTime = resultTime + "." + millisecondsString
        
        return  resultTime
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
    
    override func timeUpdated() {
        NSNotificationCenter .defaultCenter().postNotificationName(RidingTimeClock.TimeUpdatedNotification, object: nil)
    }
    
}
