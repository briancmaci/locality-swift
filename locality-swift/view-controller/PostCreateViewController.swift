//
//  PostCreateViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class PostCreateViewController: LocalityPhotoBaseViewController, ImageUploadViewDelegate,UITextViewDelegate {

    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var captionError: UILabel!
    
    @IBOutlet weak var imageUploadView: ImageUploadView!
    @IBOutlet weak var postFromView: PostFromView!
    
    @IBOutlet weak var isEmergencySwitch: UISwitch!
    
    @IBOutlet weak var publishPostButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeaderView()
        initButtons()
        initEmergencySwitch()
        initImageUploadView()
        initCaption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reload photo
        postFromView.updateProfilePhoto()
        //startLocationServices()
    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        
        header.initAttributes(title: K.String.Header.CreatePostHeader.localized,
                              leftType: .back,
                              rightType: .close)
        
        view.addSubview(header)
    }
    
    func initButtons() {
        publishPostButton.addTarget(self, action: #selector(publishDidTouch), for: .touchUpInside)
    }
    
    func initEmergencySwitch() {
        
        isEmergencySwitch.addTarget(self, action: #selector(isEmergencyDidSwitch), for: .valueChanged)
    }
    
    func initImageUploadView() {
        imageUploadView.delegate = self
    }
    
    func initCaption() {
        captionField.delegate = self
        captionField.text = K.String.Post.CaptionDefault.localized
        
        captionError.text?.removeAll()
    }
    
//    func startLocationServices() {
//        if locationManager == nil {
//            locationManager = CLLocationManager()
//        }
//        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//    }
    
    //CTA
    func publishDidTouch(sender:UIButton) {
        
        if captionField.text == K.String.Post.CaptionDefault.localized {
            captionError.text = K.String.Post.CaptionError.localized
            return
        }
        
        //CREATE POST_ID NOW!!!!
        let thisPostId = Util.generateUUID()
        
        LoadingViewManager.showLoading()
        
        if !imageUploadView.hasImage() {
            createPostToWrite(pid: thisPostId)
        }
        
        else {
            PhotoUploadManager.uploadPhoto(image: imageUploadView.getImage(), type: .post, uid: CurrentUser.shared.uid, pid:thisPostId) { (metadata, error) in
                
                if error != nil {
                    print("Upload Error: \(String(describing: error?.localizedDescription))")
                    LoadingViewManager.hideLoading()
                }
                
                else {
                    let downloadURL = metadata!.downloadURL()!.absoluteString
                    self.createPostToWrite(pid: thisPostId, url: downloadURL, avg: self.imageUploadView.getAverageColorHex())
                    
                }
            }
        }
    }
    
    func isEmergencyDidSwitch(sender: UISwitch) {
        
        print("Switched! \(isEmergencySwitch.isOn)")
    }
    
    func createPostToWrite(pid: String, url: String = "", avg: String = K.Color.defaultHex) {
        let thisPost:UserPost = UserPost(coord: CurrentUser.shared.myLastRecordedLocation,                                         caption: self.captionField.text,
            imgUrl: url,
            user: CurrentUser.shared)
        
        thisPost.postId = pid
        thisPost.averageColorHex = avg
        //check anonymous
        if self.postFromView.isAnonymous == true {
            thisPost.isAnonymous = true
        }
        
        thisPost.isEmergency = isEmergencySwitch.isOn
        
        LoadingViewManager.updateLoading(label: "Uploading post")
        
        FirebaseManager.write(post: thisPost, completionHandler: { (error) in
            if error != nil {
                print("Post Write Error: \(String(describing: error?.localizedDescription))")
            }
                
            else {
                print("Post was written!")
                
                //Write Location
                GeoFireManager.write(postLocation: CLLocation(latitude: thisPost.lat, longitude: thisPost.lon), postId: thisPost.postId, completionHandler: { (error) in
                    
                    if error != nil {
                        print("Location save error: \(String(describing: error?.localizedDescription))")
                    }
                    
                    else {
                        //Location save success
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }
            
            LoadingViewManager.hideLoading()
        })
    }
    
    //MARK: - ImageUploadViewDelegate
    func takePhotoTapped() {
        takePhoto()
    }
    
    func uploadPhotoTapped() {
        selectPhoto()
    }
        
    //MARK:- RSKImageCropper Delegate Override
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        imageUploadView.setLocationImage(image: croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //clear error
        captionError.text?.removeAll()
        
        if captionField.text == K.String.Post.CaptionDefault.localized {
            captionField.text.removeAll()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if captionField.text.isEmpty {
            captionField.text = K.String.Post.CaptionDefault.localized
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }

}
