//
//  PlaySoundViewController.swift
//  PicturePerfect
//
//  Created by Edvin Lellhame on 8/10/15.
//  Copyright (c) 2015 edvin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController, AVAudioPlayerDelegate {

    var receivedAudio: RecordingAudio!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!



    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.fileURL, error: nil)
        audioPlayer.enableRate = true

        audioFile = AVAudioFile(forReading: receivedAudio.fileURL, error: nil)

        audioCategoryPlayback()
    }

    @IBAction func slowPlaybackButtonPressed(sender: UIButton) {
        playRateSpeed(0.5)
    }
    
    @IBAction func fastPlaybackButtonPressed(sender: UIButton) {
        playRateSpeed(2.0)
    }

    @IBAction func chipmunkPlaybackButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func darthPlaybackButtonPressed(sender: UIButton) {
        playAudioWithVariablePitch(-275.0)
    }

    @IBAction func reverbPlaybackButtonPressed(sender: UIButton) {
        playAudioWithReverb(70.0)
    }

    @IBAction func chipmunkVaderButtonPressed(sender: UIButton) {
        chipmunkVaderSound()
    }

    @IBAction func stopButtonPressed(sender: UIButton) {
        audioPlayerStopAndReset()
    }

    func playRateSpeed(speed: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayerStopAndReset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)

        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func chipmunkVaderSound() {
        audioPlayerStopAndReset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var chipmunkEffect = AVAudioUnitTimePitch()
        chipmunkEffect.pitch = 1000
        audioEngine.attachNode(chipmunkEffect)

        var vaderEffect = AVAudioUnitTimePitch()
        vaderEffect.pitch = -275
        audioEngine.attachNode(vaderEffect)

        audioEngine.connect(audioPlayerNode, to: vaderEffect, format: nil)
        audioEngine.connect(vaderEffect, to: chipmunkEffect, format: nil)
        audioEngine.connect(chipmunkEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func playAudioWithReverb(dryMix: Float) {
        audioPlayerStopAndReset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = dryMix
        audioEngine.attachNode(reverbEffect)

        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func audioCategoryPlayback() {
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
    }

    func audioPlayerStopAndReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}

