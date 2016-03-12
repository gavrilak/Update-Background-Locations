//
//  Tracker.swift
//  locationUpdates
//
//  Created by Vitor Oliveira on 3/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController : UIViewController, CLLocationManagerDelegate {
    
    var timer: NSTimer!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var locationManager = CLLocationManager()
    var myLastLocation: CLLocationCoordinate2D!
    var myLastLocationAccuracy: CLLocationAccuracy!
    var myLocation: CLLocationCoordinate2D!
    var myLocationAccuracy: CLLocationAccuracy!
    
    private func startLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationTracking() {
        NSLog("stopLocationTracking")
        if (self.timer != nil) {
            self.timer.invalidate()
            self.timer = nil
        }
        locationManager.stopUpdatingLocation()
    }
    
    func restartLocationUpdates() {
        NSLog("restartLocationUpdates")
        if (self.timer != nil) {
            self.timer.invalidate()
            self.timer = nil
        }
        self.startLocationManager()
    }
    
    func startLocationTracking() {
        NSLog("startLocationTracking")
        if CLLocationManager.locationServicesEnabled() == false {
            NSLog("locationServicesEnabled false")
            let alert = UIAlertController(title: "Error!", message:"Location Services Disabled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootVC?.presentViewController(alert, animated: true){}
        }
        else {
            if CLLocationManager.locationServicesEnabled() {
            //    switch(CLLocationManager.authorizationStatus()) {
            //    case .NotDetermined, .Restricted, .Denied:
            //        print("No access")
            //    case .AuthorizedAlways, .AuthorizedWhenInUse:
                NSLog("authorizationStatus authorized")
                self.startLocationManager()
             //   }
            } else {
                print("Location services are not enabled")
            }
        }
    }
    
}