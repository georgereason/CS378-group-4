////
////  DataService.swift
////  Geopoll
////
////  Created by Michael Volk on 10/23/16.
////  Copyright © 2016 cs378Group4. All rights reserved.
////
//
//import Foundation
//import FirebaseDatabase
//
//class DataService {
//    static let dataService = DataService()
//    
//    private var _BASE_REF = FIRDatabase.database().reference()
//    private var _USER_REF = FIRDatabase.database().reference(withPath: "users")
//    private var _QUESTION_REF = FIRDatabase.database().reference(withPath: "questions")
//    
//    var BASE_REF: FIRDatabaseReference {
//        return _BASE_REF
//    }
//    
//    var USER_REF: FIRDatabaseReference {
//        return _USER_REF
//    }
//    
//    var CURRENT_USER_REF: FIRDatabaseReference {
//        let userID = UserDefaults.standardUserDefaults.valueForKey("uid") as! String
//        
//        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
//        
//        return currentUser!
//    }
//    
//    var QUESTION_REF: FIRDatabase {
//        return _QUESTION_REF
//    }
//}
