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
    
    @IBOutlet weak var imageUploadView:ImageUploadView!
    @IBOutlet weak var postFromView:PostFromView!
    
    @IBOutlet weak var publishPostButton:UIButton!
    
    var currentLocation:CLLocationCoordinate2D!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeaderView()
        initImageUploadView()
        initCaption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLocationServices()
    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        
        header.initAttributes(title: K.String.Header.CreatePostHeader.localized,
                              leftType: .back,
                              rightType: .close)
        
        view.addSubview(header)
        
        
    }
    
    func initImageUploadView() {
        imageUploadView.delegate = self
    }
    
    func initCaption() {
        captionField.delegate = self
    }
    
    func startLocationServices() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
