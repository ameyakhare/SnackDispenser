//
//  HistoryTableViewController.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/22/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies container for all items that have been dispensed

import UIKit

class HistoryTableViewController: UITableViewController, UITableViewDataSource {
    
    var historyManager: HistoryManager? // history manager passed from dispenserviewcontroller
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyManager!.items.count
    }
    
    @IBAction func doneWithHistory (sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // dismiss modal view
    }
    
    @IBAction func clearHistory (sender: AnyObject) {
        historyManager?.items = [] // empty items and save
        historyManager?.save()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryViewCell", forIndexPath: indexPath) as UITableViewCell
        let history = historyManager!.items[indexPath.row]
        cell.textLabel!.text = history.item.name
        cell.imageView?.image = history.item.image
        
        var date_form = NSDateFormatter()
        date_form.dateFormat = "M/dd/yyyy, h:mm" // format date for mo/day/yr and non-army hr:min
        cell.detailTextLabel!.text = "Eaten \(date_form.stringFromDate(history.date))"
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // delete item at indexPath and save
            historyManager!.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            historyManager!.save()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // ability to delete single table cell
    }
    
}
