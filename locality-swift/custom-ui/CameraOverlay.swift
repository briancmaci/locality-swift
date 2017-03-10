//
//  CameraOverlay.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class CameraOverlay: UIView {

    @IBOutlet weak var takePictureButton:UIButton!
    @IBOutlet weak var flashButton:UIButton!
    @IBOutlet weak var cameraToggleButton:UIButton!
    @IBOutlet weak var gridButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var gridOverlay:UIImageView!

    var pickerReference:UIImagePickerController!
    
    func showCameraOverlay() {
        isHidden = false
    }
    
    
    @IBAction func takePicture(sender:UIButton) {
        pickerReference.takePicture()
        isHidden = true
    }
    
    @IBAction func toggleCamera(sender:UIButton) {
        if pickerReference.cameraDevice == .front {
            pickerReference.cameraDevice = .rear
        }
        
        else if pickerReference.cameraDevice == .rear {
            pickerReference.cameraDevice = .front
        }
    }
    
    @IBAction func closeCamera(sender:UIButton) {
        pickerReference.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleGrid(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        gridOverlay.isHidden = !sender.isSelected
    }
    
    @IBAction func toggleFlash(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        pickerReference.cameraFlashMode = sender.isSelected == true ? .on : .off
    }
    
    func resetOverlayView() {
        var cf:CGRect = self.frame
        cf.size.width = K.Screen.Width
        cf.size.height = K.Screen.Height
        self.frame = cf
        
        gridOverlay.isHidden = true
        gridButton.isSelected = false
        
        pickerReference.cameraFlashMode = .off
        flashButton.isSelected = false
        
        isHidden = false
    }
}
