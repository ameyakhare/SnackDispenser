//
//  DispenserViewController.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Contains PickerView, ability to add stock, random selection, choosing
//

import UIKit

class DispenserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var picker: UIPickerView! // infinite picker view as implemented by me
    @IBOutlet var spinButton: UIButton! // spin button shown upon load
    @IBOutlet var chooseButton: UIButton! // choose button shown upon spin
    @IBOutlet var infoField: UILabel! // displays helpful text to user
    @IBOutlet var cancelButton: UIButton! // cancel button shown upon spin
    
    var snacksManager = SnacksManager() // manager for snacks in stock
    var historyManager = HistoryManager() // manager for dispensed snacks
    
    // data for infinite scroll view, reference to reset scroll view to mid
    private var pickerViewData: [DispenserSnack] = []
    private let pickerViewRows = 10_000
    private var pickerViewMiddle: Int?
    private var chosenSnack: DispenserSnack?
    
    override func viewWillAppear(animated: Bool) {
        pickerViewData = snacksManager.snacks
        
        if snacksManager.snacks.count > 0 {
            pickerViewMiddle = ((pickerViewRows / pickerViewData.count) / 2) * pickerViewData.count
        }
        
        // set up for buttons and text fields
        infoField.text = "Spin for a snack!"
        infoField.textColor = UIColor.whiteColor()
        chooseButton.hidden = true
        cancelButton.hidden = true
        spinButton.hidden = false
        
        if snacksManager.snacks.count <= 0 {
            spinButton.enabled = false // don't let user spin if nothing there
            infoField.text = "Nothing here!"
        } else {
            spinButton.enabled = true
        }
        
        picker.reloadAllComponents() // force reload incase stock items changed
    }
    
    @IBAction func spinPressed (sender: AnyObject) {
        // set visible cancel and choose, remove spin
        chooseButton.hidden = false
        cancelButton.hidden = false
        
        // spin random row between 10 and 20
        var randRoll = picker.selectedRowInComponent(0) + Int(arc4random_uniform(UInt32(snacksManager.snacks.count)))+20
        picker.selectRow(randRoll, inComponent: 0, animated: true)
        
        // check whether the user can take this item
        var snack = valueForRow(picker.selectedRowInComponent(0))
        
        if snack!.inStock {
            chooseButton.enabled = true
            chosenSnack = snack!
            infoField.text = "\(snack!.numStock) left in stock"
        } else {
            infoField.text = "Not in stock!"
            chooseButton.enabled = false
        }
        
        spinButton.hidden = true
    }
    
    @IBAction func choosePressed (sender: AnyObject) {
        // after choosing once, don't let them choose again
        spinButton.hidden = false
        chooseButton.hidden = true
        cancelButton.hidden = true
        
        let newRow = pickerViewMiddle! + (picker.selectedRowInComponent(0) % pickerViewData.count)
        picker.selectRow(newRow, inComponent: 0, animated: false) // reset hard to middle
        
        // check for in stock has already been done (choosePressed allowed)
        chosenSnack!.numStock -= 1
        historyManager.items.insert(HistoryItem(item: chosenSnack!,date: NSDate()),atIndex: 0)
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, { // create background save thread to prevent lag
            self.snacksManager.save()
            self.historyManager.save()
        })
        
        infoField.text = "Yummy! Spin for more!"
    }
    
    @IBAction func cancelPressed (sender: AnyObject) {
        chooseButton.hidden = true
        cancelButton.hidden = true
        spinButton.hidden = false
        
        infoField.text = "Spin for a snack!"
    }
    
    override func viewDidLoad() {
        if snacksManager.snacks.count <= 0 {return;}
        
        pickerViewData = snacksManager.snacks
        pickerViewMiddle = ((pickerViewRows / pickerViewData.count) / 2) * pickerViewData.count
        
        // picker delegate reset to self to have control over movement
        self.picker.delegate = self
        self.picker.dataSource = self
        if let row = rowForValue(snacksManager.snacks[0]) {
            self.picker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    func valueForRow(row: Int) -> DispenserSnack? {
        if snacksManager.snacks.count == 0 {return nil;}
        // the rows repeat every `pickerViewData.count` items
        return snacksManager.snacks[row % snacksManager.snacks.count]
    }
    
    func rowForValue(value: DispenserSnack) -> Int? {
        for var i = 0; i < snacksManager.snacks.count; ++i {
            if value == snacksManager.snacks[i] {return pickerViewMiddle!+i;}
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var item = valueForRow(row)
        
        if let display = item {
            return "\(display.name)"
        }
        
        return ""
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewRows
    }
    
    // added functionality to include images
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView? {
        
        if snacksManager.snacks.count == 0 {return nil}
        var snack = valueForRow(row)
        
        // create view with image on left
        var view = UIView(frame: CGRectMake(pickerView.bounds.width*0.1, 0, pickerView.bounds.width*0.9, 60))
        var imageView = UIImageView(frame: CGRectMake(pickerView.bounds.width*0.2, 5, 50, 50))
        imageView.image = snack?.image
        
        // add label on right
        let label = UILabel(frame: CGRectMake(pickerView.bounds.width*0.2+70, 0, pickerView.bounds.width-90, 60 ))
        label.textColor = UIColor.whiteColor()
        label.text = snack?.name
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        return view
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToStock" {
            if let stockView = segue.destinationViewController as? StockTableViewController {
                stockView.snacksManager = self.snacksManager
            }
        }
        
        if segue.identifier == "ToHistory" {
            if let historyView = segue.destinationViewController.topViewController as? HistoryTableViewController {
                historyView.historyManager = self.historyManager
            }
        }
    }
    
}
