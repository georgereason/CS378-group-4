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

class SignInController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HEY")
        
    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        print("User signed in with facebook")
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
                            let photoURL = profile.photoURL
                            var current:USER = USER(providerID: providerID, uid: uid, name: name!, email: email!)
                            CURRENT_USER = current
                            myRootRef.child("users").child(uid).setValue(["name":name!, "email":email!]) //putting user into database
                            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
