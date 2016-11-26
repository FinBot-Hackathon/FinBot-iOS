//
//  TransactionViewController.swift
//  FinBot
//
//  Created by Marc Fiedler on 26/11/2016.
//  Copyright © 2016 Blackout Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1

class TransactionViewController: UIViewController {
    var talkOnlyOnce: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startStreaming()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            //self.sayText = results.bestTranscript
            
            if( results.bestTranscript.range(of: "Kim") != nil){
                if( !self.talkOnlyOnce ){
                    self.talkOnlyOnce = true
                    speechToText.stopRecognizeMicrophone()
                    //self.timeStart = Date()
                    //self.overloadString = self.sayText
                    
                    speechToText.stopRecognizeMicrophone()
                    IBMWatson.sharedInstance.say(withText: "I made a transaction of 200 Euros to Kim")
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
