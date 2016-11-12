//
//  Location.swift
//  Geopoll
//
//  Created by Chase LaBar on 11/8/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class Location: NSObject, CLLocationManagerDelegate
{
    var manager:CLLocationManager
    let getLiveLocation:Bool
    var loc:CLLocation?
    
    //for initiatlizing to the current location of the device
    override init()
    {
        CLLocationManager.locationServicesEnabled()
        manager = CLLocationManager()
        getLiveLocation = true
        super.init()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.requestLocation()
    }
    
    //for initializing to a given lat/long
    init(lat:Double, long:Double)
    {
        CLLocationManager.locationServicesEnabled()
        manager = CLLocationManager()
        getLiveLocation = false
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        loc = CLLocation(latitude: lat, longitude: long)
    }
    
    //called when requestLocation() completes succesfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    //called when requestLocation() completes unsuccesfully
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func isInRange(cllocation:CLLocation, maxDistance:Double) -> Bool
    {
        var currentLocation:CLLocation
        currentLocation = getLoc()
        let distance = cllocation.distance(from: currentLocation)
        return (distance < maxDistance)
    }
    
    func isInRange(location:Location, maxDistance:Double) -> Bool
    {
        return isInRange(cllocation: location.getLoc(), maxDistance: maxDistance)
    }
    
    func latitude() -> Double{
        
        return getLoc().coordinate.latitude
    }
    
    func longitude() -> Double{
        return getLoc().coordinate.longitude
    }
    
    func getLoc() -> CLLocation{
        if getLiveLocation
        {
            return manager.location!
        }
        else
        {
            return loc!
        }
    }
}
