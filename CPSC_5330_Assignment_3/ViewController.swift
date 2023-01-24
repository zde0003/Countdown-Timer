//
//  ViewController.swift
//  CPSC_5330_Assignment_3
//
//  Created by Zach Evetts on 1/16/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var liveClock: UILabel!
    
    @IBOutlet weak var timeRemaining: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var timeFormatter = DateFormatter()
    var dateFormatter = DateFormatter()
    var totalTime: Int?
    var timeLeft: Int?
    var timerCountDown = Timer()
    var audioPlayer: AVAudioPlayer?
    let player = AVQueuePlayer()
    var currentDate = Date()
    var images = [UIImage(named: "Day"), UIImage(named: "Night")]
    var isPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeRemaining.text = ""
        
        button.setTitle("Start Timer", for: .normal)
        
//        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
//        timeFormatter.dateFormat = "HH:mm:ss"
        
        getCurrentTime()
    }
    
    @IBAction func getPicker(_ sender: UIDatePicker) {
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        if isPressed == false {
            if (button.titleLabel!.text == "Start Timer") {
                totalTime = Int(datePicker.countDownDuration)
                timeLeft = totalTime
                //start the countdown
                timerCountDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            }
            self.isPressed = true
        } else {
            button.setTitle("Start Timer", for: .normal)
            player.pause()
            timerCountDown.invalidate()
            self.isPressed = false
        }
    }
    
    private func getCurrentTime() {
            timerCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
            imageChange()
        }
    
    @objc func currentTime() {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            liveClock.text = formatter.string(from: Date())
        }
    
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            timeRemaining.text = "Time Remaining: \(getTimeString(from: timeLeft!))"
            timeLeft! -= 1
        } else {
            timerCountDown.invalidate()
            button.setTitle("Stop Music", for: .normal)
            playAudio()
        }
    }
    
    func imageChange() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 0...11:
                backgroundImage.image = images[0]
            case 12...23:
                backgroundImage.image = images[1]
                liveClock.textColor = UIColor.white
                datePicker.setValue(UIColor.white, forKeyPath: "textColor")
                button.backgroundColor = UIColor.white
                timeRemaining.textColor = UIColor.white
            default:
                backgroundImage.image = images[0]
         }
    }
    
    func getTimeString(from totalSeconds: Int) -> String {
            let hours = totalSeconds / 3600
            let minutes = totalSeconds / 60 % 60
            let seconds = totalSeconds % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func playAudio() {
            if let url = Bundle.main.url(forResource: "3-01 Counterattack", withExtension: "m4a") {
                player.removeAllItems()
                player.insert(AVPlayerItem(url: url), after: nil)
                player.play()
        }
    }
}
