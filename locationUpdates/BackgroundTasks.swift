//
//  BackgroundTasks.swift
//  locationUpdates
//
//  Created by Vitor Oliveira on 3/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import Foundation
import UIKit

class BackgroundTaskManager {
    
    var taskId = UIBackgroundTaskInvalid
    var taskIdList = Array<Int>!()
    
    let application: UIApplication = UIApplication.sharedApplication()
    
    func mainBackgroundTaskManager() -> BackgroundTaskManager {
        var BGTaskManager: BackgroundTaskManager!
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            BGTaskManager = BackgroundTaskManager()
        }
        return BGTaskManager
    }
    
    func beginNewBackgroundTask() -> UIBackgroundTaskIdentifier {
        var bgTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        if application.respondsToSelector("beginBackgroundTaskWithExpirationHandler:") {
            bgTaskId = application.beginBackgroundTaskWithExpirationHandler({() -> Void in
                NSLog("background task %lu expired", UInt(bgTaskId))
                self.taskIdList.removeObject(bgTaskId)
                self.application.endBackgroundTask(bgTaskId)
                bgTaskId = UIBackgroundTaskInvalid
            })
            if self.taskId == UIBackgroundTaskInvalid {
                self.taskId = bgTaskId
                NSLog("started master task %lu", UInt(self.taskId))
            }
            else {
                NSLog("started background task %lu", UInt(bgTaskId))
                self.taskIdList.append(bgTaskId)
            }
        }
        return bgTaskId
    }
    
    private func endBackgroundTasks() {
        NSLog("end background tasks %lu", UInt(self.taskId))
        if application.respondsToSelector("endBackgroundTask:") {
            let count: Int = self.taskIdList.count
            for var i=1; i < count; i++ {
                let bgTaskId: UIBackgroundTaskIdentifier = Int(self.taskIdList[0])
                NSLog("ending background task with id -%lu", UInt(bgTaskId))
                self.application.endBackgroundTask(bgTaskId)
                self.taskIdList.removeAtIndex(0)
            }
            if self.taskIdList.count > 0 {
                NSLog("kept background task id %@", self.taskIdList[0])
            }
            NSLog("kept master background task id %lu", UInt(self.taskId))
        }
    }
    
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
    func contains<T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}