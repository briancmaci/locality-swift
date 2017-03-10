//
//  LocalityPhotoBaseViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import RSKImageCropper
import AVFoundation

class LocalityPhotoBaseViewController: LocalityBaseViewController, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate {


    func checkCameraAccess() {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authStatus == .authorized {
            showPictureOptions()
        }
        else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted == true {
                    self.showPictureOptions()
                }
                else {
                    self.cameraDenied()
                }
            })
        }
        else/* if authStatus == .restricted*/ {
            cameraDenied()
        }
    }
    
    func cameraDenied() {
        print("Camera access denied")
        
        var alertText:String!
        var alertButton:String!
        
        //var canOpenSettings:Bool = (UIApplicationOpenSettingsURLString != nil)
        
        //if canOpenSettings == true {
            alertText = "Privacy Access You --- CHANGE"
            alertButton = "Go"
        //}
        //else {
        //    alertText = "Privacy Access Us --- CHANGE"
        //    alertButton = "OK"
        //}
        
        let alert = UIAlertController(title: "locality",
                                      message:alertText,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: alertButton, style: .cancel, handler: { action in
            
            if alert.view.tag == 3491832
            {
                //let canOpenSettings:Bool = (&UIApplicationOpenSettingsURLString != NSNull)
                
                //if canOpenSettings == true {
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                //}
                
            }
            
            alert.dismiss(animated: true, completion: nil)
            
        })
        
        alert.addAction(cancelAction)
        alert.view.tag = 3491832
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Camera Flow Methods
    func showPictureOptions() {
        let other1:String = "Take Picture"
        let other2:String = "Browse Photo Library"
        let cancelTitle:String = "Cancel"
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: other1, style: .default, handler: {action in
            self.takePhoto()
        })
        
        let selectAction = UIAlertAction(title: other2, style: .default, handler: {action in
            self.selectPhoto()
        })
        
        let cancelAction = UIAlertAction(title:cancelTitle, style: .cancel, handler: {action in
            actionSheet.dismiss(animated:true, completion:nil)
        })
        
        actionSheet.addAction(takeAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated:true, completion:nil)
    }
    
    // ActionSheet styling. (ios8 has a work-around).
    
//    SEL selector = NSSelectorFromString(@"_alertController");
//    if ([actionSheet respondsToSelector:selector])
//    {
//    UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
//    if ([alertController isKindOfClass:[UIAlertController class]])
//    {
//    alertController.view.tintColor = [UIColor blackColor];
//    // font styling in UIAlertController is not working here
//    }
//    }
//    else
//    {
//    // use other methods for iOS 7 or older.
//    for (UIView *subview in actionSheet.subviews) {
//    if ([subview isKindOfClass:[UIButton class]]) {
//    UIButton *button = (UIButton *)subview;
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont fontWithName:kMainFont size:20];
//    }
//    }
//    }
//    }
    
    func selectPhoto() {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }

    func takePhoto() {
        let cameraOverlay:CameraOverlay = UIView.instanceFromNib(name: K.NIBName.CameraOverlay) as! CameraOverlay
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .off
        picker.showsCameraControls = false
        picker.cameraOverlayView = cameraOverlay
        cameraOverlay.pickerReference = picker
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.showImageCropper(image: image)
        }
    }
    
    func showImageCropper(image:UIImage) {
        let imageCropVC:RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode: .circle)
        
        imageCropVC.delegate = self
        //imageCropVC.dataSource = self
        navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    //MARK:- RSKImageCropperDelegate Methods
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        print("Image has been cropped")
    }
   
    //MARK:- RSKImageCropperDataSource Methods
    
//    
//    -(CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
//    
//    CGSize maskSize = CGSizeMake(DEVICE_WIDTH, DEVICE_WIDTH*IMAGE_RATIO);
//    
//    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
//    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
//    
//    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
//    (viewHeight - maskSize.height) * 0.5f,
//    maskSize.width,
//    maskSize.height);
//    
//    return maskRect;
//    }
//    
//    // Returns a custom path for the mask.
//    - (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
//    {
//    CGRect rect = controller.maskRect;
//    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
//    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
//    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
//    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
//    
//    UIBezierPath *rectPath = [UIBezierPath bezierPath];
//    [rectPath moveToPoint:point1];
//    [rectPath addLineToPoint:point2];
//    [rectPath addLineToPoint:point3];
//    [rectPath addLineToPoint:point4];
//    [rectPath closePath];
//    
//    return rectPath;
//    }
//    
//    
//    -(CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
//    
//    return controller.maskRect;
//    }

    
    
    



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
