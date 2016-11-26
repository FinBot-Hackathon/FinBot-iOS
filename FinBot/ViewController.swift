//
//  ViewController.swift
//  FinBot
//
//  Created by Marc Fiedler on 25/11/2016.
//  Copyright © 2016 Blackout Technologies. All rights reserved.
//

import UIKit
import TextToSpeechV1
import AVFoundation
import SpeechToTextV1
import Alamofire

class ViewController: UIViewController {
    var audioPlayer = AVAudioPlayer() // see note below
    var speechToText: SpeechToText?
    var timeStart: Date?
    var sayText: String?
    var oldSayText: String?
    
    func startStreaming() {
        let username = "5bba6dc9-5a75-4038-944e-aaf16bb83aff"
        let password = "TSYOshVIkupk"
        let speechToText = SpeechToText(username: username, password: password)

        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        let failure = { (error: Error) in print(error) }
        speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            print(results.bestTranscript)
            self.sayText = results.bestTranscript
            
            if( results.bestTranscript.range(of: "Hey") != nil){
                print("Found hey")
                self.timeStart = Date()
            }
        }
    }
    
    func stopStreaming() {
        speechToText?.stopRecognizeMicrophone()
    }

    func generateSpeech(){
        let textToSpeach = TextToSpeech(username: "c08db1f9-8f05-4cb4-b9e4-db06031e45de", password: "GwkcLsnaRA0k")
        textToSpeach.serviceURL = "https://stream.watsonplatform.net/text-to-speech/api"
        
        let text = "Welcome to FinBot. You have spend 145 Euros on Coffee this week"
        let failure = { (error: Error) in print(error) }
        textToSpeach.synthesize(text, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startStreaming()
        _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    // must be internal or public.
    func update() {
        if let startPoint = self.timeStart {
            let end = Date();   // <<<<<<<<<<   end time
            let interval: Double = end.timeIntervalSince(startPoint)
            
            print("Interval: \(interval)")
            
            if( oldSayText != sayText){
                oldSayText = sayText
                self.timeStart = Date()
            }
            
            if( interval >= 2 ){
                timeStart = nil
                self.speechToText?.stopRecognizeMicrophone()
                print("Stopping: \(self.sayText)")
                
                let watsonURL = "http://finbot-001.eu-gb.mybluemix.net/text_in?payload="+self.sayText!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                Alamofire.request(watsonURL).response { response in
                    print(response)  // original URL request
                }
                
                self.sayText = nil
                self.oldSayText = nil;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

