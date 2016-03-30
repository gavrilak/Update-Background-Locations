//
//  Tracker.swift
//  locationUpdates
//
//  Created by Vitor Oliveira on 3/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import CoreLocation

public class TrackerController : UIViewController, CLLocationManagerDelegate {
    
    public var restartTimer : Double!
    public var saveBatteryTimer : Double!
    public var trackingDistance : Double!
    public var updateLocationTimer : Double!
    
    private var updateTimer: NSTimer!
    private var timer: NSTimer!
    private var delayToStart: NSTimer!
    private var bgTask: BackgroundTaskManager!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    private var locationManager = CLLocationManager()
    
    public func location_init(){
        if UIApplication.sharedApplication().backgroundRefreshStatus == .Denied {
            showAlert("The app doesn't work without the Background App Refresh enabled. If you want to turn it on, go to Settings > General > Background App Refresh")
        } else if UIApplication.sharedApplication().backgroundRefreshStatus == .Restricted {
            showAlert("If you want to explore the functions of this app, you have to allow Background App Refresh.")
        } else {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateLocationTimer, target: self, selector: #selector(TrackerController.trackLocation), userInfo: nil, repeats: true)
        }
    }
    
    public func startLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = trackingDistance
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    public func startLocationTracking() {
        NSLog("startLocationTracking")
        if CLLocationManager.locationServicesEnabled() == false {
            NSLog("locationServicesEnabled false")
            let alert = UIAlertController(title: "Error!", message:"Location Services Disabled", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootVC?.presentViewController(alert, animated: true){}
        } else {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                    case .NotDetermined, .Restricted, .Denied:
                        print("No access")
                        self.startLocationManager()
                    case .AuthorizedAlways, .AuthorizedWhenInUse:
                        NSLog("authorizationStatus authorized")
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
            self.delayToStart = NSTimer.scheduledTimerWithTimeInterval(saveBatteryTimer, target: self, selector: #selector(TrackerController.stopLocationToSaveBattery), userInfo: nil, repeats: false)
        }

    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("locationManager error:%@",error);
    }
    
    public func trackLocation() {
        NSLog("trackLocation")
        self.updateLocationToServer()
    }
    
    public func restartLocationUpdates() {
        NSLog("restartLocationUpdates")
        if (self.timer != nil) {
            self.timer.invalidate()
            self.timer = nil
        }
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopLocationToSaveBattery() {
        NSLog("stopLocationToSaveBattery")
        locationManager.stopUpdatingLocation()
        self.delayToStart.invalidate()
        self.delayToStart = nil
        self.timer = NSTimer.scheduledTimerWithTimeInterval(restartTimer, target: self, selector: #selector(TrackerController.restartLocationUpdates), userInfo: nil, repeats: false)
    }
    
    //
    // mark: private functions
    //
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Error!", message:message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootVC?.presentViewController(alert, animated: true){}
    }
    
    private func applicationEnterBackground() {
        self.startLocationManager()
        self.bgTask = BackgroundTaskManager().mainBackgroundTaskManager()
    }

    private func updateLocationToServer() {
        NSLog("updateLocationToServer")
        NSLog("Send to Server: Latitude(%f) Longitude(%f)", self.latitude, self.longitude)
    }
    
}