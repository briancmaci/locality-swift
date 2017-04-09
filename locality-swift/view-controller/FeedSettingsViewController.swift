//
//  FeedSettingsViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/12/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Mapbox
import SDWebImage

class FeedSettingsViewController: LocalityPhotoBaseViewController, CLLocationManagerDelegate, LocationSliderFluidDelegate, ImageUploadViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, MGLMapViewDelegate, UIScrollViewDelegate, GMSAutocompleteViewControllerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var locationNameError: UILabel!
    @IBOutlet weak var slider: LocationSliderFluid!
    @IBOutlet weak var imageUploadView: ImageUploadView!
    @IBOutlet weak var scrollSaveButton: UIButton!
    @IBOutlet weak var scrollDeleteButton: UIButton!
    @IBOutlet weak var scrollDeleteButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var feedOptionsTable: UITableView!
    @IBOutlet weak var feedOptionsHeight: NSLayoutConstraint!
    
    //GeoServices
    var locationManager:CLLocationManager!
    var geocoder:GMSGeocoder!
    var feedOptions:[[String:AnyObject]] = [[String:AnyObject]]()
    
    //Mapbox
    //var sliderSteps:[RangeStep] = [RangeStep]()
    //var currentRangeIndex:Int!
    var currentRange: CGFloat!
    var currentLocation: CLLocationCoordinate2D!
    var hasMapped: Bool = false
    
    //GMSAutoComplete
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultsBackground: UIImageView!
    var resultsTableHandle: UITableView!
    var backgroundIsDrawn = false
    
    //ViewController Mode
    var isEditingFeed: Bool! = false
    var editFeed: FeedLocation?
    var photoHasBeenEdited: Bool = false
    
    //------------------------------------------------------------------------------
    // MARK: - View Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViewControllerMode()
        initialSetup()
        
        //populate with feed if editing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        cancelKeyboardNotifications()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Initial Setup
    //------------------------------------------------------------------------------
    
    func initViewControllerMode() {
        isEditingFeed = !(editFeed == nil)
    }
    
    func initialSetup() {
        
        initGMSAutoCompleteControllers()
        
        initButtons()
        initLocationName()
        initHeaderView()
        initFeedOptionsTable()
        initScrollView()
        initRangeSlider()
        initMap()
        initImageUploadView()
    }
    
    func initGMSAutoCompleteControllers() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchBarContainer.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:(searchController?.searchBar.frame.size.height)!)
        searchController?.hidesNavigationBarDuringPresentation = false
        
        setResultsBackgroundStage()
        definesPresentationContext = true
    }
    
    func initButtons() {
    
        if isEditingFeed == true {
            scrollSaveButton.setTitle(K.String.Feed.UpdateFeedLabel.localized, for: .normal)
            scrollSaveButton.addTarget(self, action: #selector(updateLocationDidTouch), for: .touchUpInside)
            
            scrollDeleteButton.setTitle(K.String.Feed.DeleteFeedLabel.localized, for: .normal)
            scrollDeleteButton.addTarget(self, action: #selector(deleteLocationDidTouch), for: .touchUpInside)
        }
        
        else {
            scrollSaveButton.setTitle(K.String.Feed.SaveFeedLabel.localized, for: .normal)
            scrollSaveButton.addTarget(self, action: #selector(saveLocationDidTouch), for: .touchUpInside)
            
            scrollDeleteButtonHeight.constant = 0
            scrollSaveButton.setNeedsUpdateConstraints()
        }
    }
    
    func initLocationName() {
        
        if !isEditingFeed {
            locationName.placeholder = K.String.Feed.FeedNameDefault.localized
        } else {
            locationName.text = editFeed?.name
        }
        
        locationName.delegate = self
        locationNameError.text?.removeAll()
    }
    
    func initHeaderView() {
        
        header.initHeaderViewStage()
        header.initAttributes(title: isEditingFeed == true ? K.String.Header.EditLocationHeader.localized : K.String.Header.AddNewLocationHeader.localized,
                              leftType: .back,
                              rightType: .none)
        
        view.addSubview(header)
    }
    
    func initFeedOptionsTable() {
        
        feedOptions = Util.getPListArray(name: K.PList.FeedOptions)
        
        feedOptionsTable.register(UINib(nibName: K.NIBName.FeedSettingsToggleCell, bundle: nil), forCellReuseIdentifier: K.ReuseID.FeedSettingsToggleCellID)
        feedOptionsTable.delegate = self
        feedOptionsTable.dataSource = self
        
        feedOptionsHeight.constant = K.NumberConstant.Feed.FeedOptionHeight * CGFloat(feedOptions.count)
        feedOptionsTable.reloadData()
    }
    
    func initScrollView() {

        scrollView.delegate = self
        
        if isEditingFeed == true {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        } else {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func initRangeSlider() {

        slider.initFluidSlider()
        slider.delegate = self
        
        if isEditingFeed == true {
            let editRange = (editFeed?.range)!
            slider.setRange(range: CGFloat(editRange))
            //slider.setStep(range:CGFloat(editRange))
        }
        currentRange = slider.getSliderValue()
    }
    
    func initMap() {
        
        map.showsUserLocation = false
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let localityStyleURL = K.Mapbox.MapStyle
        map.styleURL = URL(string:localityStyleURL)
        map.delegate = self
        
        if isEditingFeed == true {
            
            currentLocation = CLLocationCoordinate2D(latitude: (editFeed?.lat)!,
                                                     longitude: (editFeed?.lon)!)
            
            if hasMapped == false {
                map.setCenter(currentLocation, animated:false)
                updateMapRange()
                hasMapped = true
            }
            
            sliderValueChanged(value: slider.getSliderValue())
            //sliderValueChanged(step: currentRangeIndex)
        }
        
        else {
            
            //Start polling
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
        
        bindMapGestures()
    }
    
    func bindMapGestures() {
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapSingleTap))
        singleTap.delegate = self
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMapPan))
        pan.delegate = self
        
        map.addGestureRecognizer(singleTap)
        map.addGestureRecognizer(pan)
    }
    
    func initImageUploadView() {
        if isEditingFeed == true {
            //load image
            if editFeed?.feedImgUrl != K.Image.DefaultFeedHero {
                let iv:UIImageView = UIImageView(frame:CGRect(origin:CGPoint.zero, size:imageUploadView.frame.size))
                iv.sd_setImage(with: URL(string:(editFeed?.feedImgUrl)!), completed: { (img, error, type, url) in
                    
                    if img != nil {
                        self.imageUploadView.setLocationImage(image: img!)
                    }
                })
                
            }
        }
        
        imageUploadView.delegate = self
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Data & API
    //------------------------------------------------------------------------------
    
    func writeLocation(url:String) {
        let thisLocation:FeedLocation = FeedLocation(coord: self.currentLocation,
                                                     name: locationName.text!,
                                                     range: Float(slider.getSliderValue()),
                                                     current: false)
        
        thisLocation.feedImgUrl = url
        
        for op in self.feedOptionsTable.visibleCells {
            
            let c = op as! FeedSettingsToggleCell
            
            if c.data["var"] as! String == K.String.Feed.Setting.PushEnabled {
                thisLocation.pushEnabled = c.settingsSwitch.isOn
            }
                
            else if c.data["var"] as! String == K.String.Feed.Setting.PromotionsEnabled {
                thisLocation.promotionsEnabled = c.settingsSwitch.isOn
            }
        }
        
        GoogleMapsManager.reverseGeocode(coord: currentLocation) { (address, error) in
            
            if error != nil {
                thisLocation.location = "Location Unknown"
            }
            
            else
            {
                thisLocation.location = Util.locationLabel(address: address!)
            }
            
            //save to current
            CurrentUser.shared.pinnedLocations.append(thisLocation)
            
            FirebaseManager.write(pinnedLocations:CurrentUser.shared.pinnedLocations, completionHandler: { (error) in
                if error != nil {
                    print("Locations Write Error: \(String(describing: error?.localizedDescription))")
                }
                    
                else {
                    print("Location written")
                    SlideNavigationController.sharedInstance().popViewController(animated: true)
                }
            })
        }
    }
    
    func updateLocation(url:String) {
        
        //Update edit feed
        editFeed?.lat = self.currentLocation.latitude
        editFeed?.lon = self.currentLocation.longitude
        editFeed?.name = locationName.text!
        editFeed?.range = Float(slider.getSliderValue())
        editFeed?.feedImgUrl = url
        
        for op in self.feedOptionsTable.visibleCells {
            
            let c = op as! FeedSettingsToggleCell
            
            if c.data["var"] as! String == K.String.Feed.Setting.PushEnabled {
                editFeed?.pushEnabled = c.settingsSwitch.isOn
            }
                
            else if c.data["var"] as! String == K.String.Feed.Setting.PromotionsEnabled {
                editFeed?.promotionsEnabled = c.settingsSwitch.isOn
            }
        }
        
        //check if the map has been changed
        if Util.pointsEqual(currentLocation, CLLocationCoordinate2D(latitude:(editFeed?.lat)!, longitude:(editFeed?.lon)!)) {
            
            //We do not need to call reverseGeocode
            //save to current
            if (editFeed?.isCurrentLocation)! == false {
                for i in 0...CurrentUser.shared.pinnedLocations.count - 1 {
                    if CurrentUser.shared.pinnedLocations[i].locationId == editFeed?.locationId {
                        CurrentUser.shared.pinnedLocations[i] = editFeed!
                    }
                }
            }
            
            FirebaseManager.write(pinnedLocations:CurrentUser.shared.pinnedLocations, completionHandler: { (error) in
                if error != nil {
                    print("Locations Write Error: \(String(describing: error?.localizedDescription))")
                }
                    
                else {
                    print("Location written")
                    SlideNavigationController.sharedInstance().popViewController(animated: true)
                }
            })
        }
        
        else {
            GoogleMapsManager.reverseGeocode(coord: currentLocation) { (address, error) in
                
                if error != nil {
                    self.editFeed?.location = "Location Unknown"
                }
                    
                else
                {
                    self.editFeed?.location = Util.locationLabel(address: address!)
                }
                
                //save to current
                for i in 0...CurrentUser.shared.pinnedLocations.count - 1 {
                    if CurrentUser.shared.pinnedLocations[i].locationId == self.editFeed?.locationId {
                        CurrentUser.shared.pinnedLocations[i] = self.editFeed!
                    }
                }
                
                FirebaseManager.write(pinnedLocations:CurrentUser.shared.pinnedLocations, completionHandler: { (error) in
                    if error != nil {
                        print("Locations Update Error: \(String(describing: error?.localizedDescription))")
                    }
                        
                    else {
                        print("Location updated")
                        SlideNavigationController.sharedInstance().popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    func deleteLocation(_ loc:FeedLocation) {
    
        for (i, pinned) in CurrentUser.shared.pinnedLocations.enumerated() {
            if pinned.locationId == loc.locationId {
                CurrentUser.shared.pinnedLocations.remove(at: i)
            }
        }
        
        FirebaseManager.write(pinnedLocations:CurrentUser.shared.pinnedLocations, completionHandler: { (error) in
            if error != nil {
                print("Locations Delete Error: \(String(describing: error?.localizedDescription))")
            }
                
            else {
                print("Location deleted")
                SlideNavigationController.sharedInstance().popViewController(animated: true)
            }
        })
    }
    
    func writePhotoToStorage() {
        PhotoUploadManager.uploadPhoto(image: imageUploadView.getImage(), type: .location, uid: CurrentUser.shared.uid) { (metadata, error) in
            
            if error != nil {
                print("Upload Error: \(String(describing: error?.localizedDescription))")
            }
                
            else {
                let downloadURL = metadata!.downloadURL()!.absoluteString
                
                if self.isEditingFeed == true {
                    self.updateLocation(url: downloadURL)
                } else {
                    self.writeLocation(url:downloadURL)
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: - CTA Methods
    //------------------------------------------------------------------------------
    
    func saveLocationDidTouch(sender:UIButton) {
        
        if (locationName.text?.isEmpty)! {
            locationNameError.text = K.String.Feed.FeedNameError.localized
            return
        }
        
        if !imageUploadView.hasImage() {
            writeLocation(url: K.Image.DefaultFeedHero)
        }
            
        else {
            writePhotoToStorage()
        }
    }
    
    func updateLocationDidTouch(sender:UIButton) {
        
        if (locationName.text?.isEmpty)! {
            locationNameError.text = K.String.Feed.FeedNameError.localized
            return
        }
        
        if !imageUploadView.hasImage() {
            updateLocation(url: K.Image.DefaultFeedHero)
        }
            
        else {
            if photoHasBeenEdited == true || editFeed?.feedImgUrl == K.Image.DefaultFeedHero {
                writePhotoToStorage()
            }
            
            else {
                updateLocation(url: (editFeed?.feedImgUrl)!)
            }
        }
    }
    
    func deleteLocationDidTouch(sender:UIButton) {
        
        alertDelete()
    }
    
    func handleMapSingleTap(tap:UITapGestureRecognizer) {
        currentLocation = map.convert(tap.location(in: map), toCoordinateFrom: map)
        updateMapRange()
    }
    
    func handleMapPan(pan:UIPanGestureRecognizer) {
        currentLocation = map.convert(pan.location(in: map), toCoordinateFrom: map)
        updateMapRange()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - AlertView Methods
    //------------------------------------------------------------------------------
    
    func alertDelete() {
    
        showAlertView(title: K.String.Alert.Title.DeleteLocation.localized,
                      message: K.String.Alert.Message.DeleteLocation.localized,
                      close: K.String.Alert.Close.No.localized,
                      action: K.String.Alert.Action.Yes.localized)
    }
    
    override func tappedAction() {
    
        deleteLocation(editFeed!)
        alertView.closeAlert()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - CLLocationManagerDelegate Methods
    //------------------------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[0]
        currentLocation = location.coordinate
        
        if hasMapped == false {
            map.setCenter(currentLocation, animated:false)
            updateMapRange()
            hasMapped = true
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func updateMapRange() {
        
        if let annotations = map.annotations {
            for ann in annotations {
                map.removeAnnotation(ann)
            }
        }
        
        map.centerCoordinate = currentLocation
        let currentRadius:Double = Util.radiusInMeters(range: Float(slider.getSliderValue()))
        
        let rangePointSW:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: -currentRadius, metersLong: -currentRadius)
        
        let rangePointNE:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: currentRadius, metersLong: currentRadius)
        
        let bounds = MGLCoordinateBoundsMake(rangePointSW, rangePointNE)
        
        map.setVisibleCoordinateBounds(bounds, edgePadding: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), animated: false)
        
        let rangeCircle = MapboxManager.polygonCircleForCoordinate(coordinate: map.centerCoordinate,
                                                                   meterRadius: currentRadius)
        map.add(rangeCircle)
        
        let rangeMarker = CustomPointAnnotation()
        rangeMarker.coordinate = map.centerCoordinate
        rangeMarker.markerType = K.Mapbox.Marker.Type.Range
        map.addAnnotation(rangeMarker)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UIScrollViewDelegate Methods
    //------------------------------------------------------------------------------s
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.bounces = scrollView.contentOffset.y > 20
        
        if searchController?.searchBar.isFirstResponder == false {
            searchController?.searchBar.alpha = ((searchController?.searchBar.frame.size.height)! - scrollView.contentOffset.y)/(searchController?.searchBar.frame.size.height)!
        }
        
        if searchController?.searchBar.isFirstResponder == true {
            searchController?.searchBar.alpha = 1.0
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: - ImageUploadViewDelegate Methods
    //------------------------------------------------------------------------------
    
    func takePhotoTapped() {
        takePhoto()
    }
    
    func uploadPhotoTapped() {
        selectPhoto()
    }
    
    func selectedPhotoHasBeenRemoved() {
        
        if isEditingFeed == true {
            photoHasBeenEdited = true
        }
    }
    
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        imageUploadView.setLocationImage(image: croppedImage)
        dismiss(animated: true, completion:nil)
        
    }
    
    //------------------------------------------------------------------------------
    // MARK: - LocationRangeSliderFluidDelegate Methods
    //------------------------------------------------------------------------------
    
    func sliderValueChanged(value: CGFloat) {
    
        currentRange = value
        updateMapRange()
    }
    
//    func sliderValueChanged(step: Int) {
//    
//        currentRangeIndex = step
//        updateMapRange()
//    }
    
    func updateMap(place:CLLocationCoordinate2D) {
        
        currentLocation = place
        updateMapRange()
    }

    //------------------------------------------------------------------------------
    // MARK: - KeyboardNotifications Methods
    //------------------------------------------------------------------------------
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(keyboardWillShow),
                                               name: .UIKeyboardDidShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(keyboardWillHide),
                                               name:.UIKeyboardWillHide,
                                               object:nil)
        
    }
    
    func cancelKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardDidShow,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                   name:.UIKeyboardWillHide,
                                                   object:nil)
        
    }
   
    func keyboardWillShow(notification:Notification) {
        
        //We only wish to do this for the locationName
        if !locationName.isFirstResponder {
            return
        }
        
        let info:[String:AnyObject] = notification.userInfo as! [String : AnyObject]
        
        var keyboardFrame:CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let locOrigin:CGPoint = locationName.frame.origin
        let locHeight:CGFloat = locationName.frame.size.height
        
        var visibleRect:CGRect = scrollView.frame
        
        visibleRect.size.height -= (keyboardFrame.size.height)
        
        if visibleRect.contains(locOrigin) == false {
            let scrollPoint:CGPoint = CGPoint(x:0.0, y:keyboardFrame.size.height - locOrigin.y - locHeight)
            
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
        
    }
    
    func keyboardWillHide(notification:Notification) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - MGLMapViewDelegate Methods
    //------------------------------------------------------------------------------
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.2
    }
    
    private func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.clear
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return K.Color.localityMapAccent
    }
    
    private func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        let thisMarker = annotation as! CustomPointAnnotation
        
        switch thisMarker.markerType {
            
        case K.Mapbox.Marker.Type.Range:
            let img = UIImage(named: K.Mapbox.Marker.Image.Range)
            let mglImg = MGLAnnotationImage(image: img!, reuseIdentifier: K.Mapbox.Marker.Type.Range)
            mglImg.accessibilityFrame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
            return mglImg
            
        default:
            return MGLAnnotationImage(image: UIImage(), reuseIdentifier: "")
        }
    }

    //------------------------------------------------------------------------------
    // MARK: - UITextFieldDelegate Methods
    //------------------------------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        locationNameError.text?.removeAll()
        
        if locationName.text == K.String.Feed.FeedNameDefault.localized {
            locationName.text?.removeAll()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if locationName.text?.isEmpty == true {
            locationName.text = K.String.Feed.FeedNameDefault.localized
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Methods
    //------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.NumberConstant.Feed.FeedOptionHeight
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate Methods
    //------------------------------------------------------------------------------
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let toggleCell:FeedSettingsToggleCell = tableView.dequeueReusableCell(withIdentifier: K.ReuseID.FeedSettingsToggleCellID, for: indexPath) as! FeedSettingsToggleCell
        
        toggleCell.populate(data: feedOptions[indexPath.row])

        if isEditingFeed == true {
            if toggleCell.data["var"] as! String == K.String.Feed.Setting.PushEnabled {
                toggleCell.settingsSwitch.setOn((editFeed?.pushEnabled)!, animated: false)
            } else if toggleCell.data["var"] as! String == K.String.Feed.Setting.PromotionsEnabled {
                toggleCell.settingsSwitch.setOn((editFeed?.promotionsEnabled)!, animated: false)
            }
        }
        
        return toggleCell
    }
   
    //------------------------------------------------------------------------------
    // MARK: - GMSAutoCompleteViewControllerDelegate Methods
    //------------------------------------------------------------------------------
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("GMSAutoCompleteViewController Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //------------------------------------------------------------------------------
    // MARK: - GMSAutoCompleteResultsViewControllerDelegate Methods
    //------------------------------------------------------------------------------
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        self.updateMap(place: place.coordinate)
        self.locationName.text = place.name
        
        backgroundIsDrawn = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        
        if backgroundIsDrawn == false {
            drawResultsBackground()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setResultsBackgroundStage() {
        
        for sub in (resultsViewController?.view.subviews)! {
            if type(of: sub) == UITableView.self {
                resultsTableHandle = sub as! UITableView
            }
        }
    }
    
    func drawResultsBackground() {
    
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        resultsBackground = UIImageView(image: screenshot)
        resultsTableHandle.backgroundView = resultsBackground
        backgroundIsDrawn = true
    }
    
    
    //------------------------------------------------------------------------------
    // MARK: - SlideNavigationControllerDelegate Methods
    //------------------------------------------------------------------------------
    
    override func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
}
