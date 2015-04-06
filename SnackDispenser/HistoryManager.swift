//
//  PeopleManager.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies a manager for history items

import Foundation
import UIKit

class HistoryManager {
    
    var items = [HistoryItem]()
    
    // create archive path based on available url with addition "HistoryItems"
    lazy private var archive_path: String = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        let archiveURL = documentDirectoryURLs.first!.URLByAppendingPathComponent("HistoryItems", isDirectory: false)
        return archiveURL.path!
        }()
    
    // archive to file pointed to by archivePath
    func save() {
        NSKeyedArchiver.archiveRootObject(items, toFile: archive_path)
    }
    
    // use same archivePath to unarchive items
    private func unarchiveSavedItems() {
        if NSFileManager.defaultManager().fileExistsAtPath(archive_path) {
            let savedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(archive_path) as [HistoryItem]
            items = savedItems
        }
    }
    
    init() {
        unarchiveSavedItems()
    }
    
}