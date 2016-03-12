//
//  AppDelegate.swift
//  locationUpdates
//
//  Created by Vitor Oliveira on 3/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var updateTimer: NSTimer!

    let tracker = LocationController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.location_init()
        self.tracker.startLocationTracking()
        return true
    }
    
    private func location_init(){
        if UIApplication.sharedApplication().backgroundRefreshStatus == .Denied {
            self.showAlert("The app doesn't work without the Background App Refresh enabled. If you want to turn it on, go to Settings > General > Background App Refresh")
        } else if UIApplication.sharedApplication().backgroundRefreshStatus == .Restricted {
            self.showAlert("If you want to explore the functions of this app, you have to allow Background App Refresh.")
        } else {
            let time: NSTimeInterval = 10.0
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "trackLocation", userInfo: nil, repeats: true)
        }
    }
    
    func trackLocation() {
        NSLog("trackLocation")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Error!", message:message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootVC?.presentViewController(alert, animated: true){}
    }
    
}