//
//  MeetingViewController.swift
//  Jitsi - iOS
//
//  Created by LIUYE on 9/24/15.
//  Copyright © 2015 LIUYE. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class MeetingViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func lock(sender: AnyObject) {
        var passwordTextField: UITextField?
        let alertController = UIAlertController(title: "Lock the Meeting", message: "Enter your password to lock the meeting", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            passwordTextField = textField
            passwordTextField?.placeholder = "Enter your password"
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func openCamera(sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
            let alert = UIAlertController(title: "No camera", message: "Please allow this app the use of your camera in settings or buy a device that has a camera.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        NSLog("Received image from camera")
        let mediaType = info[UIImagePickerControllerMediaType as String]
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        let compResult:CFComparisonResult = CFStringCompare(mediaType as! NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            imgView.image = imageToSave
            imgView.reloadInputViews()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
