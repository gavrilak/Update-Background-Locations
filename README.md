# iOS Update Background Locations
This is a simple Swift class to provide all the configurations that you need to get background locations. 
 
It's compatible with the latest Swift syntax if you're using any Swift version prior to 2.0.
 
# If you want to test:
Clone the project and execute in your simulator.
 
# How to use in your project:
First add BackgroundTasks.swift and Tracker.swift to your project.
<BR><BR>
Instantiate the class:<BR><BR>
```let tracker = LocationController()```
<BR><BR>
To start the service, configure distanceFilter property. Distance filter is the minimum distance (measured in meters) a device must move horizontally before an update event is generated.:<BR><BR>
```tracker.trackingDistance = 100.0```
<BR><BR>
Set the timer to stop the tracker to save battery (seconds):<BR><BR>
```tracker.updateLocationTimer = 10.0```
<BR><BR>
Set the timer to restart the manager to save battery (seconds):<BR><BR>
```tracker.restartTimer = 5```
<BR><BR>
Set the timer to stop the tracker to save battery (seconds):<BR><BR>
```tracker.saveBatteryTimer = 5```
<BR><BR>
Set the timer to stop the tracker to save battery (seconds):<BR><BR>
``` tracker.startLocationTracking() ```
<BR><BR>
Don't forget to add the following lines in your plist file:<BR><BR>
<img src="https://github.com/vbrazo/iOS_Update_Background_Locations/blob/master/readme.images/plist_info.png?raw=true">
<BR>


# Contributing:
I encourage you to contribute to this repository.
  
# Updated for:
Swift 2.0 (Xcode 7.2)
