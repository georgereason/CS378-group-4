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
    var answeredBy: [String : String]
    var location: Location
    var maxDistance: Double
    
    init(text: String, addedByUser: String, answers: [String:Int], key: String = "", answeredBy: [String : String], location:Location, maxDistance:Double) {
        self.key = key
        self.text = text
        self.addedByUser = addedByUser
        self.answers = answers
        self.ref = nil
        self.answeredBy = answeredBy
        self.location = location
        self.maxDistance = maxDistance
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.text = snapshotValue["text"] as! String
        self.addedByUser = snapshotValue["addedByUser"] as! String
        self.answers = snapshotValue["answers"] as! [String:Int]
        self.maxDistance = snapshotValue["maxDistance"] as! Double
        if let value = snapshotValue["answeredBy"] {
            self.answeredBy = value as! [String : String]
        }
        else {
            self.answeredBy = [:]
        }
        if let coord = snapshotValue["coordinates"]{
            let lat = coord["latitude"] as! Double
            let long = coord["longitude"] as! Double
            self.location = Location(lat: lat, long: long)
        }
        else
        {
            //not sure what to do when location can't be retrieved
            self.location = Location(lat: 0, long: 0)
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        let coordinates: [String:Double] = [
            "latitude" : location.latitude(),
            "longitude" : location.longitude()
        ]

        return [
            "text": self.text,
            "addedByUser": addedByUser,
            "answers": self.answers,
            "answeredBy": self.answeredBy,
            "coordinates": coordinates,
            "maxDistance": self.maxDistance
        ]
    }
}
