//
//  TodoList.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez   & Oscar Barrera Casillas on 02/06/16.
//  Copyright © 2016 CODE. All rights reserved.
// Class to define badge, body of local notification


import Foundation
import UIKit

class TodoList {
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    func allItems() -> [TodoItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map(
            {
                TodoItem(deadline: $0["deadline"] as! NSDate,
                    title: $0["title"] as! String,
                    UUID: $0["UUID"] as! String!,
                    Repeating: NSCalendarUnit(rawValue: $0["repeatInterval"] as! UInt))
                
            })
            .sort({(left: TodoItem, right:TodoItem) -> Bool in
                    (left.deadline.compare(right.deadline) == .OrderedAscending)
                })
    }
    
    func GetValue(string:NSString) -> UInt{
        return  UInt(string.intValue);
    }
    
    
    func addItem(item: TodoItem) {
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID,"repeatInterval":item.repeatInterval.rawValue] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
      //  notification.alertBody = "CODE Tarea: \"\(item.title)\" ha empezado" // text that will be displayed in the notification
        notification.alertBody = "Alarma CODE ver video" 
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        notification.repeatInterval = item.repeatInterval
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //self.setBadgeNumbers()
    }
    
    func removeItem(item: TodoItem,force:Bool = false) {
        
        if(item.repeatInterval != NSCalendarUnit.Era || force){
            for notification in (UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]?)! { // loop through notifications...
                if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                    UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                    break
                }
            }
            
            if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
                todoItems.removeValueForKey(item.UUID)
                NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
            }
        }
        
        
        
        // self.setBadgeNumbers()
    }
    
    func scheduleReminderforItem(item: TodoItem) {
        let notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Recordatorio sCODE Tarea:  \"\(item.title)\" ha empezado" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate().dateByAddingTimeInterval(5 * 60) // 5 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "TODO_CATEGORY"
        notification.repeatInterval = item.repeatInterval
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    /*
    func setBadgeNumbers() {
        var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]? // all scheduled notifications
        var todoItems: [TodoItem] = self.allItems()
        
        for notification in notifications! {
            var overdueItems = todoItems.filter({ (todoItem) -> Bool in // array of to-do items...
                return (todoItem.deadline.compare(notification.fireDate!) != .OrderedDescending) // ...where item deadline is before or on notification fire date
            })
            
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = overdueItems.count // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }*/
}