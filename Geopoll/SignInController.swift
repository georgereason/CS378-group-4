//
//  SignInController.swift
//  Geopoll
//
//  Created by George Reason on 10/14/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import Foundation
import UIKit

class SignInController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        print("User signed in with facebook")
    }
    
    @IBAction func twitterButton(_ sender: AnyObject) {
        print("User signed in with twitter")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
