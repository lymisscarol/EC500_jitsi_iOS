//
//  ViewController.swift
//  Jitsi - iOS
//
//  Created by LIUYE on 9/24/15.
//  Copyright © 2015 LIUYE. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func start(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
//            picker.showsCameraControls = false
        }
        else{
            NSLog("No Camera.")
            let alert = UIAlertController(title: "No camera", message: "Please allow this app the use of your camera in settings or buy a device that has a camera.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
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
            //imgView.image = imageToSave
            UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
            //imgView.reloadInputViews()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBOutlet weak var cameraOverlay: UIView!
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        
//        let camera = UIImagePickerController()
//        camera.delegate = self
//        camera.allowsEditing = false
//        camera.sourceType = UIImagePickerControllerSourceType.Camera
//        camera.showsCameraControls = false
//        
//        NSBundle.mainBundle().loadNibNamed("CameraOverlay", owner: self, options: nil)
//        cameraOverlay.frame = (camera.cameraOverlayView?.frame)!
//        camera.cameraOverlayView = cameraOverlay
//        cameraOverlay = nil
//        
//        self.presentViewController(camera, animated: false, completion: nil)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

