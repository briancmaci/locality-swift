//
//  PostCreateViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class PostCreateViewController: LocalityPhotoBaseViewController, ImageUploadViewDelegate, CLLocationManagerDelegate, UITextViewDelegate {

    @IBOutlet weak var captionField:UITextView!
    @IBOutlet weak var captionError:UILabel!
    
    @IBOutlet weak var imageUploadView:ImageUploadView!
    @IBOutlet weak var postFromView:PostFromView!
    
    @IBOutlet weak var publishPostButton:UIButton!
    
    var currentLocation:CLLocationCoordinate2D!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeaderView()
        initButtons()
        initImageUploadView()
        initCaption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reload photo
        postFromView.updateProfilePhoto()
        startLocationServices()
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
    
    func initImageUploadView() {
        imageUploadView.delegate = self
    }
    
    func initCaption() {
        captionField.delegate = self
        captionField.text = K.String.Post.CaptionDefault.localized
        
        captionError.text?.removeAll()
    }
    
    func startLocationServices() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    //CTA
    func publishDidTouch(sender:UIButton) {
        
        if captionField.text == K.String.Post.CaptionDefault.localized {
            captionError.text = K.String.Post.CaptionError.localized
            return
        }
        
        //CREATE POST_ID NOW!!!!
        let thisPostId = Util.generateUUID()
        
        if !imageUploadView.hasImage() {
            createPostToWrite(url: "", pid:thisPostId)
        }
        
        else {
            PhotoUploadManager.uploadPhoto(image: imageUploadView.getImage(), type: .post, uid: CurrentUser.shared.uid, pid:thisPostId) { (metadata, error) in
                
                if error != nil {
                    print("Upload Error: \(error?.localizedDescription)")
                }
                
                else {
                    let downloadURL = metadata!.downloadURL()!.absoluteString
                    self.createPostToWrite(url:downloadURL, pid:thisPostId)
                    
                }
            }
        }
    }
    
    func createPostToWrite(url:String, pid:String) {
        let thisPost:UserPost = UserPost(coord: self.currentLocation,
                                         caption: self.captionField.text,
                                         imgUrl: url,
                                         user: CurrentUser.shared)
        
        thisPost.postId = pid
        
        //check anonymous
        if self.postFromView.isAnonymous == true {
            thisPost.isAnonymous = true
        }
        
        FirebaseManager.write(post: thisPost, completionHandler: { (success, error) in
            if error != nil {
                print("Post Write Error: \(error?.localizedDescription)")
            }
                
            else {
                print("Post written!")
                
                //Write Location
                GeoFireManager.write(postLocation: CLLocation(latitude: thisPost.lat, longitude: thisPost.lon), postId: thisPost.postId, completionHandler: { (success, error) in
                    
                    if error != nil {
                        print("Location save error: \(error?.localizedDescription)")
                    }
                    
                    else {
                        //Location save success
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
    }
    
    //MARK: - ImageUploadViewDelegate
    func takePhotoTapped() {
        takePhoto()
    }
    
    func uploadPhotoTapped() {
        selectPhoto()
    }
    
    //MARK:- CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[0]
        currentLocation = location.coordinate
        
        locationManager.stopUpdatingLocation()
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

}
