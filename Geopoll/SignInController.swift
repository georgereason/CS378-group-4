//
//  SignInController.swift
//  Geopoll
//
//  Created by George Reason on 10/14/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import CoreLocation

var myLocation: Location = Location() //declared here to make it global

class SignInController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "city_background.jpg")!)
        CLLocationManager.locationServicesEnabled()
        myLocation = Location()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        let loginManager = LoginManager()
        // Create reference to a Firebase location
        let myRootRef = FIRDatabase.database().reference() //getting database

        
        
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in //this is the firebase login method
                    // ...
                    FIRAuth.auth()?.currentUser?.link(with: credential) { (user1, error) in //this method will link a user's facebook login with their twitter login
                        
                    }
                    
                    // this conditional is just an example of how we can access a user's info easily
                    if let user3 = FIRAuth.auth()?.currentUser {
                        
                        for profile in user3.providerData {
                            let providerID = profile.providerID
                            let uid = profile.uid;  // Provider-specific UID
                            let name = profile.displayName
                            let email = profile.email
                            let photoURL = "\(profile.photoURL!)"
                            let currentUser = FIRAuth.auth()?.currentUser
                            let userUID = "\((currentUser?.uid)!)"
                            myRootRef.child("users").child(userUID).setValue(["name":name!, "email":email!, "imageURL":photoURL, "gender":0, "movie":"", "id":userUID]) //putting user into database
                        }
                        
                    self.performSegue(withIdentifier: "facebookSegue", sender: self)
                    } else {
                        // No user is signed in.
                    }
                }
            }
        }
    }
    
//    @IBAction func twitterButton(_ sender: AnyObject) {
//        print("User signed in with twitter")
//
//    }
//    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
//        
//        if (self.respondsToSelector(action)) {
//            
//            return self.unwindHere.on;
//            
//        }
//        
//        return false;
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
