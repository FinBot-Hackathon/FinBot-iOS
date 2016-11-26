//
//  QueryViewController.swift
//  FinBot
//
//  Created by Marc Fiedler on 26/11/2016.
//  Copyright © 2016 Blackout Technologies. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func queryTouched(_ sender: Any) {
        print("Querying Watson")
        IBMWatson.sharedInstance.say(withText: "My analysis of your previous expenditures shows that your Vacation in Dubai won't be possible bevore 8 Months time except you adjust your saving plan.")
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
