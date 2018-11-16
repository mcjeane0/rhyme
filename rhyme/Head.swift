//
//  Head.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation


extension Dot : FaceDelegate {
    
    func handlePressBegan() {
        startRecordingCommands()
    }
    
    func handlePressEnded() {
        stopRecordingCommands()
    }
    
    func handleTap() {
        attemptPurchaseTip()
    }
    
    func handleSwipeLeft(){
        if possibleRhymes.count > 0 {
            let nextIndex = currentRhymeIndex - 1 > 0 ? currentRhymeIndex - 1 : possibleRhymes.count - 1
            currentRhymeIndex = nextIndex
            utter(possibleRhymes[currentRhymeIndex])
        }
    }
    
    func handleSwipeRight(){
        if possibleRhymes.count > 0 {
            let nextIndex = currentRhymeIndex + 1 < possibleRhymes.count - 1 ? currentRhymeIndex + 1 : 0
            currentRhymeIndex = nextIndex
            utter(possibleRhymes[currentRhymeIndex])
        }
        
    }
    
    func handleSwipeUp(){
        
    }
    
    func handleSwipeDown(){
        if possibleRhymes.count > 0 {
            utter(possibleRhymes[currentRhymeIndex])
        }
    }
    
    
    
    
}
