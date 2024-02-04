//
//  ViewController.swift
//  Tyler Remy CPSC 5330 Assignment 4
//
//  Created by user251942 on 2/3/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var dayBackground: UIImageView!
    @IBOutlet weak var nightBackground: UIImageView!
    //Date Picker
    @IBOutlet weak var picker: UIDatePicker!
    //Start/Stop Button
    @IBOutlet weak var StartStopButton: UIButton!
    //Label for displaying current date time
    @IBOutlet weak var timeLabel: UILabel!
    //Label for displaying count down remaining
    @IBOutlet weak var countdownDisplay: UILabel!
    //Timer for updating current date time
    var timer = Timer()
    //Default value of 60 seconds
    var countTime:Int = 60
    //Timer for countdown
    var timer2 = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownDisplay.sizeToFit()
        countdownDisplay.text = ""
        picker.backgroundColor = .white
        
        getCurrentTime()
        //startCountdown()
    }
    
    func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.currentTime), userInfo: nil, repeats: true)
    }
        
    @IBAction func timeSelection(_ sender: UIDatePicker) {
        countTime = Int(sender.countDownDuration)
    
        
    }
    
    @IBAction func countdownButton(_ sender: UIButton) {
        
        timer2.invalidate()
        if countTime > 0 {
            startCountdown()
        }
        
        //If playing music and button pressed, stop music and change button to "Start"
        if let player = player, player.isPlaying{
            player.stop()
            StartStopButton.setTitle("Start", for: .normal)
            countdownDisplay.text = ""
            
        }
    
    }
    
    //Start Timed Countdown
    func startCountdown() {
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
    }
    
    //Display current date/time and adjust backgrounds
    @objc func currentTime() {
        //Formate current date time to correct formate and display on label
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
        let dateTimeString = formatter.string(from: Date())
        timeLabel.text = dateTimeString
        
        //Get AM/PM and change background accordingly
        let daynightFormatter = DateFormatter()
        daynightFormatter.dateFormat = "aa"
        let daynightString = daynightFormatter.string(from: Date())
        if daynightString == "PM" {
            nightBackground.isHidden = false
            dayBackground.isHidden = true
        } else {
            nightBackground.isHidden = true
            dayBackground.isHidden = false
        }
        
    }
    
    //Start countdown timer based on user selection, play music when finished
    @objc func countDown() {
        if countTime >= 0 {
            
            //Format into to required style
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, . second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            let formattedString = formatter.string(from: TimeInterval(countTime))!
            
            countdownDisplay.text = ("Time Remaining: \(formattedString)")
            countTime -= 1
        }
        else {
            timer2.invalidate()
            StartStopButton.setTitle("Stop Music", for: .normal)
            countdownDisplay.text = "Playing Music"
            
            //I am using MacInCloud and cannot hear audio so it is difficult to try to debug if music is playing
            playSong()
            
        }
    }
    
    //Play auburn fight song
    func playSong() {
        let url = Bundle.main.path(forResource:"AUFightSong", ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let url = url
            else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            
            guard let player = player 
            else {
                return
            }
            player.play()
            
        }
        catch {
            print("error while trying to play audio")
        }
            
    }


}

