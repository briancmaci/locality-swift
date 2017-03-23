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

class LocalityPhotoBaseViewController: LocalityBaseViewController, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
    
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
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Camera Flow Methods
    func showPictureOptions() {
        let other1:String = "Take Picture"
        let other2:String = "Browse Photo Library"
        let cancelTitle:String = "Cancel"
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: other1, style: .default, handler: {action in
            self.takePhoto()
        })
        
        let selectAction = UIAlertAction(title: other2, style: .default, handler: {action in
            self.selectPhoto()
        })
        
        let cancelAction = UIAlertAction(title:cancelTitle, style: .destructive, handler: {action in
            actionSheet.dismiss(animated:true, completion:nil)
        })
        
        actionSheet.addAction(takeAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        UIApplication.topViewController()?.present(actionSheet, animated:true, completion:nil)
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
        
        UIApplication.topViewController()?.present(picker, animated: true, completion: nil)
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
        
        UIApplication.topViewController()?.present(picker, animated: true, completion: nil)
    }
    
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.showImageCropper(image: image)
//        } else{
//            print("LocalityPhotoBaseVC:imagePickerController:didFinishPicking Error")
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let image:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.showImageCropper(image: image)
            }
            
            else {
                print("ImagePicker:didFinishPicking error")
            }
        }
    }
    
    func showImageCropper(image:UIImage) {
        let imageCropVC:RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode:.custom)
        
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        imageCropVC.avoidEmptySpaceAroundImage = true
        styleImageCropper(vc: imageCropVC)
        UIApplication.topViewController()?.present(imageCropVC, animated: true)
    }
    
    func styleImageCropper(vc:RSKImageCropViewController) {
        
        vc.moveAndScaleLabel.font = UIFont(name: K.FontName.InterstateLightCondensed,
                                           size: 24)
        
        vc.moveAndScaleLabel.text = vc.moveAndScaleLabel.text?.uppercased()
        
        let cancelTitle = NSAttributedString(string: "Cancel",
                                             attributes: [NSFontAttributeName : UIFont(name: K.FontName.InterstateLightCondensed, size:16)!, NSForegroundColorAttributeName: UIColor.white])
        
        vc.cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        
        let chooseTitle = NSAttributedString(string: "Choose",
                                             attributes: [NSFontAttributeName : UIFont(name: K.FontName.InterstateLightCondensed, size:16)!, NSForegroundColorAttributeName: UIColor.white])
        
        vc.chooseButton.setAttributedTitle(chooseTitle, for: .normal)
    }
    
    //MARK:- RSKImageCropperDelegate Methods
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        //_ = navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        print("Image has been cropped")
    }
   
    //MARK:- RSKImageCropperDataSource Methods
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let maskSize:CGSize = CGSize(width: K.Screen.Width, height: K.Screen.Width * K.NumberConstant.Post.ImageRatio)
        let vw:CGFloat = controller.view.frame.size.width
        let vh:CGFloat = controller.view.frame.size.height
        
        let maskRect:CGRect = CGRect(x: (vw - maskSize.width)/2,
                                     y: (vh - maskSize.height)/2,
                                     width: maskSize.width,
                                     height: maskSize.height)
        
        return maskRect
    }
    
    @available(iOS 3.2, *)
    public func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        let rect:CGRect = controller.maskRect
        
        let point1:CGPoint = CGPoint(x:rect.minX, y:rect.maxY)
        let point2:CGPoint = CGPoint(x:rect.maxX, y:rect.maxY)
        let point3:CGPoint = CGPoint(x:rect.maxX, y:rect.minY)
        let point4:CGPoint = CGPoint(x:rect.minX, y:rect.minY)
        
        let path:UIBezierPath = UIBezierPath()
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.close()
        
        return path
    }
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
