//
//  Ear.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation

import Speech
import CoreData
import NaturalLanguage

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Array where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}

extension Dot : AVAudioRecorderDelegate {
    
    
    
    func interpret(_ result:SFSpeechRecognitionResult, _ url:URL){
        NSLog("result.transcriptions.count:\(result.transcriptions.count)")
        let segmentsCount = result.bestTranscription.segments.count
        let averageConfidenceOfBestTranscription = result.bestTranscription.segments.map { (segment) -> Float in
            return segment.confidence
            }.reduce(Float(0.0), {
                average, nextValue in
                (average + (nextValue/Float(segmentsCount)))
            })
        NSLog("result.bestTranscription.segments.confidence:\(averageConfidenceOfBestTranscription)")
        
        let formattedString = result.bestTranscription.formattedString
        self.playerUtteranceFormattedString = formattedString
        // Send string to web!!
        fetchExactRhymes(formattedString) { (possibleExactRhymes) in
            self.fetchApproximateRhymes(formattedString, completion: { (possibleApproximateRhymes) in
                self.possibleRhymes = []
                if possibleExactRhymes.count > 0 {
                    self.possibleRhymes.append(contentsOf:possibleExactRhymes)
                    for exactRhyme in possibleExactRhymes {
                        if var arrayOfUtteredRhymes = UserDefaults.standard.array(forKey: formattedString) as? [String] {
                            if !arrayOfUtteredRhymes.contains(exactRhyme) {
                                //UserDefaults.standard.set(arrayOfUtteredRhymes.append(exactRhyme), forKey: formattedString)
                                self.prepareToUtter(exactRhyme)
                                return
                            }
                        }
                        else {
                            //UserDefaults.standard.set([exactRhyme], forKey: formattedString)
                            self.prepareToUtter(exactRhyme)
                            return
                        }
                    }
                    
                }
                if possibleApproximateRhymes.count > 0 {
                    self.possibleRhymes.append(contentsOf:possibleApproximateRhymes)
                    for approximateRhyme in possibleApproximateRhymes {
                        if var arrayOfUtteredRhymes = UserDefaults.standard.array(forKey: formattedString) as? [String] {
                            if !arrayOfUtteredRhymes.contains(approximateRhyme) {
                                //UserDefaults.standard.set(arrayOfUtteredRhymes.append(approximateRhyme), forKey: formattedString)
                                self.prepareToUtter(approximateRhyme)
                                return
                            }
                        }
                        else {
                            //UserDefaults.standard.set([approximateRhyme], forKey: formattedString)
                            self.prepareToUtter(approximateRhyme)
                            return
                        }
                    }
                }
                
                if self.possibleRhymes.count > 0 {
                    self.prepareToUtter(self.possibleRhymes[self.currentRhymeIndex])
                }
                else{
                    // MARK: look up phrase in user defaults and repeat a known rhyme...
                    if var arrayOfUtteredRhymes = UserDefaults.standard.array(forKey: formattedString) as? [String] {
                        self.currentRhymeIndex = 0
                        self.possibleRhymes = arrayOfUtteredRhymes
                        self.prepareToUtter(self.possibleRhymes[self.currentRhymeIndex])
                    }
                    else {
                        // MARK: make up a fake word that doesn't really exist but definitely rhymes
                        
                    }
                    
                }
            })
            
        }
        
        
        
    }
    
    func checkSpeechRecognitionAuthorization(){
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            break
        case .denied:
            break
        case .notDetermined:
            proposeSpeechRecognitionAuthorization()
            break
        case .restricted:
            
            break
        }
    }
    
    func proposeSpeechRecognitionAuthorization(){
        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
            self.checkSpeechRecognitionAuthorization()
        }
    }
    
    func checkRecordabilityAuthorization(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case .denied:
            break
        case .granted:
            addSpeechRecognitionRecorder()
            break
        case .undetermined:
            proposeRecordabilityAuthorization()
            break
        }
    }
    
    func proposeRecordabilityAuthorization(){
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            self.checkRecordabilityAuthorization()
        }
    }
    
    fileprivate func newRecorder(_ uuid:UUID) throws -> AVAudioRecorder {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("walkieConversationPhrase-\(uuid.uuidString).m4a")
        NSLog("creating:\(uuid.uuidString)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        return try AVAudioRecorder(url: audioFilename, settings: settings)
    }
    
    func addSpeechRecognitionRecorder(){
        do {
            try speechRecognitionRecorder = newRecorder(UUID())
            speechRecognitionRecorder?.delegate = self
        }
        catch{
            NSLog("addSpeechRecognitionRecorder error: \(error)")
        }
    }
    
    
    func recognizeAndInterpret(_ url:URL){
        let speechRecognitionRequest = SFSpeechURLRecognitionRequest(url: url)
        speechRecognitionRequest.shouldReportPartialResults = false
        speechRecognitionRequest.taskHint = .search
        self.speechRecognitionRequests.append(speechRecognitionRequest)
        if speechRecognizer.isAvailable {
            speechRecognizer.recognitionTask(with: self.speechRecognitionRequests.first!) { (possibleSpeechRecognitionResult, possibleRecognitionTaskError) in
                if let speechRecognitionResult = possibleSpeechRecognitionResult {
                    
                    self.speechRecognitionResults.append(speechRecognitionResult)
                    self.interpret(speechRecognitionResult, url)
                }
                else {
                    
                }
                if let recognitionTaskError = possibleRecognitionTaskError{
                    
                    NSLog("recognitionTaskErrorCode: \(recognitionTaskError._code)")
                }
                /*
                 do {
                 try FileManager.default.removeItem(at: url)
                 NSLog("removed:\(url.lastPathComponent)")
                 }
                 catch{
                 NSLog("removeItem:error:\(error)")
                 }
                 */
            }
            DispatchQueue.main.async {
                self.speechRecognitionRequests.removeFirst()
            }
        }
        else {
            NSLog("!speechRecognizer.isAvailable due to internet problems probably")
        }
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if recorder == speechRecognitionRecorder {
            if error != nil {
                NSLog("audioRecorderEncodeErrorDidOccur: \(error!)")
            }
            else{
                NSLog("audioRecorderEncodeErrorDidOccur: nil")
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            if recorder == speechRecognitionRecorder {
                recognizeAndInterpret(recorder.url)
                addSpeechRecognitionRecorder()
                
                
            }
        }
        else{
            //startListening()
            NSLog("!flag")
        }
    }
    
    func startRecordingCommands(){
        speechRecognitionRecorder?.record()
    }
    
    func stopRecordingCommands(){
        speechRecognitionRecorder?.stop()
    }
    
}

