//
//  TodoItem.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez on 02/06/16.
//  Copyright © 2016 CODE. All rights reserved.
// class to model an object for the alarms

import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    var repeatInterval : NSCalendarUnit
    
    init(deadline: NSDate, title: String, UUID: String, Repeating:NSCalendarUnit = NSCalendarUnit.Era) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
        self.repeatInterval = Repeating
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}