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
        
    }
    
    
    
    
}
