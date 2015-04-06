//
//  StockTableViewController.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies the view for items in the dispenser

import UIKit

class StockTableViewController: UITableViewController, UITableViewDataSource {
    
    var snacksManager: SnacksManager? // manager passed on by dispenserviewcontroller
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snacksManager!.snacks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StockViewCell", forIndexPath: indexPath) as UITableViewCell
        let snack = snacksManager!.snacks[indexPath.row]
        cell.textLabel!.text = snack.name
        cell.detailTextLabel!.text = "\(snack.numStock) left in stock"
        
        // ui settings
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        cell.imageView?.image = snack.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // ability to delete single table cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // delete row option upon swipe, delete on press
            snacksManager!.snacks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            snacksManager!.save()
        }
    }
    
    @IBAction func doneAddingSnack(segue: UIStoryboardSegue) {
        if segue.identifier == "DoneItem" {
            let addViewController = segue.sourceViewController as AddSnackViewController
            if let newSnack = addViewController.newSnack {
                snacksManager!.snacks.append(newSnack)
                // save upon return from addsnackviewcontroller
                snacksManager!.save()
            }
        }
    }
    
}
