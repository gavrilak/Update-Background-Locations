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
    
    internal var saveBatteryTimer : Double!
    internal var trackingDistance : Double!
    internal var updateLocationTimer : Double!
    
    var updateTimer: NSTimer!
    var timer: NSTimer!
    var delayToStart: NSTimer!
    var bgTask: BackgroundTaskManager!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var locationManager = CLLocationManager()
    var myLastLocation: CLLocationCoordinate2D!
    var myLastLocationAccuracy: CLLocationAccuracy!
    var myLocation: CLLocationCoordinate2D!
    var myLocationAccuracy: CLLocationAccuracy!
    
    func location_init(){
        if UIApplication.sharedApplication().backgroundRefreshStatus == .Denied {
            showAlert("The app doesn't work without the Background App Refresh enabled. If you want to turn it on, go to Settings > General > Background App Refresh")
        } else if UIApplication.sharedApplication().backgroundRefreshStatus == .Restricted {
            showAlert("If you want to explore the functions of this app, you have to allow Background App Refresh.")
        } else {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateLocationTimer, target: self, selector: "trackLocation", userInfo: nil, repeats: true)
        }
    }
    
    func trackLocation() {
        NSLog("trackLocation")
        self.updateLocationToServer()
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Error!", message:message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootVC?.presentViewController(alert, animated: true){}
    }
    
    private func startLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = trackingDistance
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func restartLocationUpdates() {
        NSLog("restartLocationUpdates")
        if (self.timer != nil) {
            self.timer.invalidate()
            self.timer = nil
        }
        self.locationManager.startUpdatingLocation()
    }
    
    func applicationEnterBackground() {
        self.startLocationManager()
        self.bgTask = BackgroundTaskManager().mainBackgroundTaskManager()
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
                switch(CLLocationManager.authorizationStatus()) {
                    case .NotDetermined, .Restricted, .Denied:
                        print("No access")
                    case .AuthorizedAlways, .AuthorizedWhenInUse:
                        NSLog("authorizationStatus authorized")
                    self.startLocationManager()
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        NSLog("locationManager didUpdateLocations")
        
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
        
        NSLog("\(self.latitude)")
        NSLog("\(self.longitude)")
        
        if (self.timer != nil) {
            return
        }
            
        self.bgTask = BackgroundTaskManager().mainBackgroundTaskManager()
        self.bgTask.beginNewBackgroundTask()
        
        //stop the locationManager to save battery
        if (self.delayToStart == nil) {
            self.delayToStart = NSTimer.scheduledTimerWithTimeInterval(saveBatteryTimer, target: self, selector: "stopLocationToSaveBattery", userInfo: nil, repeats: false)
        }

    }
    
    func stopLocationToSaveBattery() {
        NSLog("locationManager stop Updating")
        locationManager.stopUpdatingLocation()
        self.delayToStart.invalidate()
        self.delayToStart = nil
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "restartLocationUpdates", userInfo: nil, repeats: false)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("locationManager error:%@",error);
    }
    
    func updateLocationToServer() {
        NSLog("updateLocationToServer")
        NSLog("Send to Server: Latitude(%f) Longitude(%f)", self.latitude, self.longitude)
    }
    
}