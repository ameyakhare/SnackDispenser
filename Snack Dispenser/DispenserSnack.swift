//
//  Snack.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies a single dispenser snack item, with image and name

import UIKit

class DispenserSnack: NSObject, NSCoding {
    
    // dispenser snack keys for encoding
    let nameKey = "NameKey"
    let imageKey = "ImageKey"
    let stockKey = "StockKey"
    
    // dispenser snack attributes
    var name: String
    var image: UIImage?
    var numStock:Int
    var inStock: Bool {
        return numStock > 0
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: nameKey)
        aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: imageKey)
        aCoder.encodeObject(numStock, forKey: stockKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(nameKey) as String
        
        // UIImage does not conform to NSCoder protocols -> NOTE
        var png: NSData = aDecoder.decodeObjectForKey(imageKey) as NSData
        image = UIImage(data:png)
        
        numStock = aDecoder.decodeObjectForKey(stockKey) as Int
    }
    
    init(name: String, image: UIImage, stock: Int) {
        self.name = name
        self.image = image
        self.numStock = stock
    }
    
}
