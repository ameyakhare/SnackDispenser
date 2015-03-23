//
//  SnacksManager.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies the manager for all the snacks in the dispenser

import Foundation

class SnacksManager {
    
    var snacks = [DispenserSnack]()
    
    // create archive path based on available url with addition "DispenserSnacks"
    lazy private var archivePath: String = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        let archiveURL = documentDirectoryURLs.first!.URLByAppendingPathComponent("DispenserSnacks", isDirectory: false)
        return archiveURL.path!
    }()
    
    // archive to file pointed to by archivePath
    func save() {
        NSKeyedArchiver.archiveRootObject(snacks, toFile: archivePath)
    }
    
    // use same archivePath to unarchive items
    private func unarchiveSavedItems() {
        if NSFileManager.defaultManager().fileExistsAtPath(archivePath) {
            let savedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath) as [DispenserSnack]
            snacks = savedItems
        }
        
        // check whether app is being opened without snacks, save defaults
        if snacks.count <= 0 {
            snacks = Defaults().def
            save()
        }
    }
    
    init() {
        unarchiveSavedItems()
    }
    
}