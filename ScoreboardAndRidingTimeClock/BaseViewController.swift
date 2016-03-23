//
//  BaseViewController.swift
//  ScoreboardAndRidingTimeClock
//
//  Created by David Rice on 2/2/16.
//  Copyright © 2016 DrsCreations. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

protocol BuzzerSoundPlayer {
    func playBuzzer(buzzerSoundPath_: String);
}
/**
* Creating base class for common functionality among viewcontrollers,
* biggest purpose will be for bluetooth sharing once I figure it out
**/
class BaseViewController: UIViewController {

    
    var audioPlayer = AVAudioPlayer()
    
    func playBuzzer(buzzerSoundPath_: String) {
        var buzzerSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Wrong Buzzer", ofType: "wav")!)
        if(buzzerSoundPath_ != "") {
            buzzerSound = NSURL(fileURLWithPath:
                NSBundle.mainBundle().pathForResource(buzzerSoundPath_, ofType: "wav")!)
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: buzzerSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error getting the audio file")
        }
    }
    
    func bluetoothShare() {
        
    }
}

