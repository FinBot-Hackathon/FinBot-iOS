//
//  IBMWatson.swift
//  FinBot
//
//  Created by Marc Fiedler on 26/11/2016.
//  Copyright © 2016 Blackout Technologies. All rights reserved.
//

import UIKit

import TextToSpeechV1
import AVFoundation

class IBMWatson: NSObject {
    static let sharedInstance = IBMWatson()
    var audioPlayer = AVAudioPlayer() // see note below
    
    func say(withText text:String){
        let textToSpeach = TextToSpeech(username: "c08db1f9-8f05-4cb4-b9e4-db06031e45de", password: "GwkcLsnaRA0k")
        textToSpeach.serviceURL = "https://stream.watsonplatform.net/text-to-speech/api"

        let failure = { (error: Error) in print(error) }
        textToSpeach.synthesize(text, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
    }
}
