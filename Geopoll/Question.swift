//
//  Question.swift
//  Geopoll
//
//  Created by Michael Volk on 10/23/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import Foundation
import Firebase

struct Question {
    
    let key: String
    let text: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var answers: [String:Int]
    
    init(text: String, addedByUser: String, answers: [String:Int], key: String = "") {
        self.key = key
        self.text = text
        self.addedByUser = addedByUser
        self.answers = answers
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.text = snapshotValue["text"] as! String
        self.addedByUser = snapshotValue["addedByUser"] as! String
        self.answers = snapshotValue["answers"] as! [String:Int]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "text": self.text,
            "addedByUser": addedByUser,
            "answers": self.answers
        ]
    }
}
