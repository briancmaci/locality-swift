//
//  LeftMenuViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LeftMenuViewController: LocalityPhotoBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    
    @IBOutlet weak var likesLabel:UILabel!
    @IBOutlet weak var postsLabel:UILabel!
    
    //Constraints for likes and posts UILabels
    @IBOutlet weak var likesWidth:NSLayoutConstraint!
    @IBOutlet weak var postsWidth:NSLayoutConstraint!
    @IBOutlet weak var postsIconRight:NSLayoutConstraint!
    
    @IBOutlet weak var menuTable:UITableView!
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    
    @IBOutlet weak var termsButton:UIButton!
    @IBOutlet weak var copyrightLabel:UILabel!
    
    @IBOutlet weak var updatePhotoButton:UIButton!
    
    var menuOptions:[[String:AnyObject]] = [[String:AnyObject]]()
    var viewHasLoaded:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHasLoaded = true

        initPhotoButton()
        initTermsCopyright()
        initMenuOptions()
        initTableView()
        
        loadTotals()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        populateMenuWithUser()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateMenuWithUser() {
        
        if !viewHasLoaded {
            return
        }
        
        initProfileImage()
        initLabels()
    }
    
    func initProfileImage() {
        profileImage.loadProfileImage(url: CurrentUser.shared.profileImageUrl)
        profileImage.encircled()
    }
    
    func initPhotoButton() {
        updatePhotoButton.addTarget(self, action: #selector(updatePhotoDidTouch), for: .touchUpInside)
    }
    
    func initLabels() {
        nameLabel.text = CurrentUser.shared.username
        statusLabel.text = UserStatus.stringFrom(type: CurrentUser.shared.status).localized
    }
    
    func initTermsCopyright() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        copyrightLabel.text = String(format:K.String.CopyrightVersionFormat.localized,
                                     year,
                                     Bundle.main.buildVersionNumber!,
                                     Bundle.main.releaseVersionNumber!)
        
        termsButton.setTitle(K.String.Button.Terms.localized, for: .normal)
    }
    
    func initMenuOptions() {
        menuOptions = Util.getPListArray(name: K.PList.MenuOptions)
    }
    
    func initTableView() {
        menuTable.delegate = self
        menuTable.dataSource = self
        
        menuTable.register(UINib(nibName: K.NIBName.LeftMenuCell, bundle: nil), forCellReuseIdentifier: K.ReuseID.LeftMenuCellID)
        
        menuTable.separatorStyle = .none
        
        tableHeight.constant = CGFloat(menuOptions.count) * K.NumberConstant.Menu.RowHeight
        menuTable.layoutIfNeeded()
        
        menuTable.isScrollEnabled = false
    }
    
    //Data
    func loadTotals() {
        var postsTotal:Int = 0
        var likesTotal:Int = 0
        
        FirebaseManager.getTotalLikes { (likes) in
            if likes != nil {
                likesTotal = likes!
            }
            
            if likesTotal == 1 {
                self.likesLabel.text = String(format:K.String.Menu.LikesOneFormat.localized, likesTotal)
            } else {
                self.likesLabel.text = String(format:K.String.Menu.LikesMultiFormat.localized, likesTotal)
            }
            
            self.likesWidth.constant = self.likesLabel.intrinsicContentSize.width
            self.likesLabel.layoutIfNeeded()
        }
        
        FirebaseManager.getTotalPosts { (posts) in
            if posts != nil {
                postsTotal = posts!
            }
            
            if postsTotal == 1 {
                self.postsLabel.text = String(format:K.String.Menu.PostsOneFormat.localized, postsTotal)
            } else {
                self.postsLabel.text = String(format:K.String.Menu.PostsMultiFormat.localized, postsTotal)
            }
            
            self.postsWidth.constant = self.postsLabel.intrinsicContentSize.width
            self.postsLabel.layoutIfNeeded()
        }
    }
    
    //CTA
    func updatePhotoDidTouch(sender:UIButton) {
        showPictureOptions()
    }
    

    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let image:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.showImageCropper(image: image)
            }
                
            else {
                print("ImagePicker:didFinishPicking error")
            }
        }
    }
    
    override func showImageCropper(image:UIImage) {
        let imageCropVC:RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode:.circle)
        
        imageCropVC.avoidEmptySpaceAroundImage = true
        styleImageCropper(vc: imageCropVC)
        
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        UIApplication.topViewController()?.present(imageCropVC, animated: true)
    }
    
    override func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        profileImage.image = croppedImage
        
        ////THIS MAY CHANGE LATER. LET'S JUST STORE THE IMAGE NOW
        PhotoUploadManager.uploadPhoto(image: croppedImage, type: .profile, uid: CurrentUser.shared.uid) { (metadata, error) in
            
            if error == nil {
                //print("PROFILE PHOTO UPLOADED!!!")
                let pathFormat = "%@/%@/%@"
                let path:String = String(format:pathFormat, K.DB.Table.Users, CurrentUser.shared.uid, K.DB.Var.ProfileImageURL)
                
                FIRDatabase.database().reference().child(path).setValue(metadata?.downloadURL()?.absoluteString)
                CurrentUser.shared.profileImageUrl = (metadata?.downloadURL()?.absoluteString)!
                
                UIApplication.topViewController()?.dismiss(animated: true, completion: {
                    //print("We should see the image in the side menu. We should save it now.")
                    SlideNavigationController.sharedInstance().open(MenuLeft) {
                        //print("Menu open? \(SlideNavigationController.sharedInstance().isMenuOpen())")
                    }
                })
            }
        }
       
    }
    
    override func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        UIApplication.topViewController()?.dismiss(animated: true, completion: {
            //print("We should see the image in the side menu. We should save it now.")
            SlideNavigationController.sharedInstance().open(MenuLeft) {
                //print("Menu open? \(SlideNavigationController.sharedInstance().isMenuOpen())")
            }
        })
    }
    
    //Menu Action Methods
    func gotoViewControllerWithId(id:String) {
        
        if id == K.Storyboard.ID.Settings {
            
            let vc = SettingsViewController(nibName: K.NIBName.VC.Settings, bundle: nil)
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: vc, withSlideOutAnimation:false, andCompletion: nil)
            return
        } else if id == K.Storyboard.ID.About {
            
            let vc = AboutViewController(nibName: K.NIBName.VC.About, bundle: nil)
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: vc, withSlideOutAnimation:false, andCompletion: nil)
            return
        }
        
        if id != K.Storyboard.ID.FeedMenu {
            let newVC:LocalityBaseViewController = Util.controllerFromStoryboard(id: id) as! LocalityBaseViewController
            
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: newVC, withSlideOutAnimation: false, andCompletion: nil)
        }
        
        else {
            let menuVc = FeedMenuTableViewController(nibName: K.NIBName.VC.FeedMenu, bundle: nil)
            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: menuVc, withSlideOutAnimation: false, andCompletion: nil)
        }
    }
    
    func triggerActionWithId(id:String) {
        print("Trigger: \(id)")
        
        if id == "logout" {
            //logout()
            showLogoutAlert()
        }
    }
    
    func showLogoutAlert() {
        
        SlideNavigationController.sharedInstance().closeMenu { 
            self.showAlertView(title: K.String.Alert.Title.Logout.localized,
                               message: K.String.Alert.Message.Logout.localized,
                               close: K.String.Alert.Close.No.localized,
                               action: K.String.Alert.Action.Yes.localized)
        }
    }
    
    //AlertViewDelegate Methods
    
    override func tappedAction() {
        
        logout()
        alertView.closeAlert()
    }
    
    //Trigger CTAs
    func logout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
            CurrentUser.shared.reset()
            
            let vc = LandingViewController(nibName: K.NIBName.VC.Landing, bundle: nil)
            SlideNavigationController.sharedInstance().popAllAndSwitch(to: vc, withSlideOutAnimation: false, andCompletion: nil)
        } catch {
            print("Logout error")
        }
    }
    
    //MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.ReuseID.LeftMenuCellID, for: indexPath) as! LeftMenuCell
        
        let thisOption = menuOptions[indexPath.row]
        
        cell.optionLabel.text = (thisOption["title"] as? String)?.localized
        
        switch SlideMenuAttributes.styleFromString(style: thisOption["style"] as! String) {
        case .light:
            cell.optionLabel.textColor = K.Color.leftNavLight
            
        case .dark:
            cell.optionLabel.textColor = K.Color.leftNavDark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let thisOption:[String:AnyObject] = menuOptions[indexPath.row]
        
        switch SlideMenuAttributes.actionFromString(action: thisOption["nav_type"] as! String) {
            
        case .segue:
            gotoViewControllerWithId(id: thisOption["storyboard_id"] as! String)
        
        
        case .action:
        triggerActionWithId(id: thisOption["action_id"] as! String)
        
        case .unknown:
        print("Error. We should not have an unknown MenuActionType")
        }
        //deselect
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.NumberConstant.Menu.RowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
