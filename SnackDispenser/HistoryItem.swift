//
//  HistoryItem.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/22/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies an object of a dispenser item and a date

import UIKit

class HistoryItem: NSObject, NSCoding {
    
    // dispenser snack keys for encoding
    let itemKey = "DispenserKey"
    let dateKey = "DateKey"
    
    // dispenser snack attributes
    var item: DispenserSnack
    var date: NSDate
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(item, forKey: itemKey)
        aCoder.encodeObject(date, forKey: dateKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        item = aDecoder.decodeObjectForKey(itemKey) as DispenserSnack
        date = aDecoder.decodeObjectForKey(dateKey) as NSDate
    }
    
    init(item: DispenserSnack, date: NSDate) {
        self.item = item
        self.date = date
    }
    
}
