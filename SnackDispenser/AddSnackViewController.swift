//
//  AddSnackViewController.swift
//  SnackDispenser
//
//  Created by Ameya Khare on 3/21/15.
//  Copyright (c) 2015 ameyakhare. All rights reserved.
//
//  Embodies modal view to add a snack to stock

import UIKit

class AddSnackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newSnack: DispenserSnack? // snack to be created
    var newSnackImage: UIImage? // contains uiimage, referenced to see if image has been selected
    
    @IBOutlet weak var nameField: UITextField! // name of dispenser snack
    @IBOutlet weak var picButton: UIButton! // button to select picture
    @IBOutlet weak var stockField: UITextField! // amount in stock
    
    @IBAction func cancel (sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // dismiss modal view
    }
    
    @IBAction func chooseImage (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            // present modal view to camera
            imagePicker.sourceType = .Camera
        } else {
            // present modal view to library
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        newSnackImage = photo
        dismissViewControllerAnimated(true, completion: {
            // change image to give user feedback for selecting an image
            self.picButton.setImage(UIImage(named:"changeImage.png"), forState: UIControlState.Normal)
            })
    }
    
    // only calls prepareforsegue if shouldperformseguewithidentifier returns true
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if !allFieldsFilled() {
            var alert = UIAlertView(title: "Oops!",
                message: "Looks like you're missing something!",
                delegate:self, cancelButtonTitle: "OK");
            alert.show();
            
            return false
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        nameField.resignFirstResponder()
        stockField.resignFirstResponder()
        // check for proper segue
        if segue.identifier == "DoneItem" {
            // check to see if all appropriate fields filled already completed
            let stock:Int = stockField.text.toInt()!
            newSnack = DispenserSnack(name:nameField.text,image:newSnackImage!,stock:stock)
        }
    }
    
    // return true if all fields are appropriately filled, image is chosen
    func allFieldsFilled () -> Bool {
        if nameField.text.isEmpty {return false;}
        if let image = newSnackImage {} else {return false;}
        
        return !stockField.text.isEmpty
    }
    
}
