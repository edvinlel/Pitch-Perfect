//
//  ViewController.swift
//  PicturePerfect
//
//  Created by Edvin Lellhame on 8/10/15.
//  Copyright (c) 2015 edvin. All rights reserved.
//

/*
    I didn't realize until later that I named it PicturePerfect and not PitchPerfect by mistake.
*/
import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet var recordingLabel: UIButton!
    @IBOutlet var playLabel: UIButton!
    @IBOutlet var stopLabel: UIButton!
    @IBOutlet var doneLabel: UIButton!

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordedAudio: RecordingAudio!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        playLabel.hidden = true
        doneLabel.hidden = true
        stopLabel.hidden = true
    }


    @IBAction func recordingButtonPressed(sender: UIButton) {
        recordingLabel.enabled = false
        stopLabel.hidden = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let audioName = "audio.wav"
        let pathArray = [dirPath, audioName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        recordedAudio = RecordingAudio(fileURL: filePath!, title: audioName)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        println("audioRecorder: \(audioRecorder)")
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        println("after record(): \(audioRecorder)")
    }

    @IBAction func stopButtonPressed(sender: UIButton) {
        playLabel.hidden = false
        doneLabel.hidden = false
        audioRecorder.stop()
    }
    
    @IBAction func playButtonPressed(sender: UIButton) {
        // play audio recording
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.fileURL, error: nil)
        audioPlayer.enableRate = true

        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
        audioPlayer.enableRate = true

        playRateSpeed(1.0)
    }

    @IBAction func doneButtonPressed(sender: UIButton) {
        doneLabel.hidden = true
        stopLabel.hidden = true
        playLabel.hidden = true
        recordingLabel.enabled = true

        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let vc: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            vc.receivedAudio = recordedAudio
    }



    func playRateSpeed(speed: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
}

