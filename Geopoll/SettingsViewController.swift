//
//  SettingsViewController.swift
//  Geopoll
//
//  Created by Nathan Poag on 10/27/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var movieField: UITextField!
    @IBOutlet weak var genderField: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var rewardPoints: UILabel!
    
    var userID:String = "";
    var currentUser:AnyObject = {} as AnyObject;
    
    let userRef = FIRDatabase.database().reference(withPath: "users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRootRef = FIRDatabase.database().reference()
        let currentUser = FIRAuth.auth()?.currentUser

        for profile in (currentUser?.providerData)! {
            userID = (currentUser?.uid)!
            
            myRootRef.queryOrdered(byChild: "users").observe(.childAdded, with: { snapshot in
                print(snapshot)
                for childSnap in snapshot.children.allObjects {
                    let snap = childSnap as! FIRDataSnapshot
                    if (snap.key == self.userID) {
                        print("CURRENT USER")
                        print(snap)
                        self.currentUser = snap.value! as AnyObject
                        self.nameField.text = self.currentUser["name"]! as! String?
                        self.emailField.text = self.currentUser["email"]! as! String?
                        self.movieField.text = self.currentUser["movie"]! as! String?
                        let points = self.currentUser["rewardPoints"]! as! Int?
                        self.rewardPoints.text = "\(points!)"
                        self.genderField.selectedSegmentIndex = (self.currentUser["gender"]! as! Int?)!
                        let url = NSURL(string: (self.currentUser["imageURL"] as? String)!)
                        let data = NSData(contentsOf: url as! URL)
                        if (data?.length)! > 0 {
                            self.userPhoto.image = UIImage(data:data! as Data)
                        } else {
                            // In this when data is nil or empty then we can assign a placeholder image
                            self.userPhoto.image = UIImage(named: "blank.png")
                        }
                    }
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutUser(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("Sign out should have occured \(FIRAuth.auth()?.currentUser)")
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    
    @IBAction func submitUserProfileChanges(_ sender: AnyObject) {
        let myRootRef = FIRDatabase.database().reference()
        let name = nameField.text
        let email = emailField.text
        let movie = movieField.text
        let genderIndex = genderField.selectedSegmentIndex
        
        let userToUpdate = myRootRef.child("users").child(self.userID)
        userToUpdate.updateChildValues(["name":name!, "email":email!, "movie":movie!, "gender":genderIndex ])
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
