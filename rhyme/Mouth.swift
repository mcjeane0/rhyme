//
//  Mouth.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import AVKit

extension Dot : AVSpeechSynthesizerDelegate {
    
    func configureAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: [.allowBluetoothA2DP, .allowAirPlay, .mixWithOthers,.defaultToSpeaker])
            speechSynthesizer.delegate = self
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        }
        catch{
            NSLog("catch configure audio session")
        }
    }
    
    func prepareToUtter(_ string:String){
        //stopListening()
        //utteranceQueue.append(string)
        utter(string)
    }
    
    func utter(_ string:String){
        voiceImpactFeedbackGenerator.prepare()
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = self.speechSynthesisVoice
        face.dispatchDotState(string)
        speechSynthesizer.speak(utterance)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        voiceImpactFeedbackGenerator.impactOccurred()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }
    
}
