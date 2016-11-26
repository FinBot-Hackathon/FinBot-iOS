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
import SwiftyJSON

class ViewController: UIViewController {
    var audioPlayer = AVAudioPlayer() // see note below
    var speechToText: SpeechToText?
    var timeStart: Date?
    var sayText: String?
    var oldSayText: String?
    var overloadString: String?
    
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
            
            if( results.bestTranscript.range(of: "Kim") != nil){
                speechToText.stopRecognizeMicrophone()
                self.timeStart = Date()
                self.overloadString = self.sayText
                
                speechToText.stopRecognizeMicrophone()
                IBMWatson.sharedInstance.say(withText: "I made a transaction of 200 Euros to Kim")
            }
        }
    }
    
    func stopStreaming() {
        speechToText?.stopRecognizeMicrophone()
    }
    
    func makeTransaction(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //startStreaming()
        //_ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        let watsonURL = "http://finbot-001.eu-gb.mybluemix.net/conversation?question=transfer%20200%20Euro%20%20to%20kim"
        Alamofire.request(watsonURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                print(json["output"]["text"][0])
                let text = json["output"]["text"][0].string
                //IBMWatson.sharedInstance.say(withText: text!)
            case .failure(let error):
                print(error)
            }
        }
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
                
                let sendString = sayText!.replacingOccurrences(of: self.overloadString!, with: "")
                print("Removing: \(self.overloadString)")
                print("Sending actually: \(sendString)")
                
                let watsonURL = "http://finbot-001.eu-gb.mybluemix.net/text_in?payload="+sendString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                /*Alamofire.request(watsonURL).response { response in
                    print(response)  // original URL request
                }*/
                
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

