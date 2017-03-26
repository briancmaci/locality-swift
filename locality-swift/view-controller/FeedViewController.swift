//
//  FeedViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox
import SWTableViewCell

class FeedViewController: LocalityBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SortButtonDelegate, SWTableViewCellDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var headerHero:FlexibleFeedHeaderView!
    @IBOutlet weak var postsTable:UITableView!
    @IBOutlet weak var flexHeaderHeight:NSLayoutConstraint!
    @IBOutlet weak var sortButton:SortButtonWithPopup!
    @IBOutlet weak var postButton:UIButton!
    @IBOutlet weak var noPostsLabel:UILabel!
    
    let headerExpandedOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
    
    var thisFeed:FeedLocation!
    var isMyCurrentLocation:Bool = false //We ALWAYS want to update the feed current location
    
    //DataSource
    var posts:[UserPost] = [UserPost]()
    
    //Updating location constantly
    var locationManager:CLLocationManager!
    
    var sizingCell:PostFeedCell!
    
    var COORDINATE_TEST_VIEW:UILabel!
    
    //------------------------------------------------------------------------------
    // MARK: - View Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if thisFeed == CurrentUser.shared.currentLocationFeed {
                isMyCurrentLocation = true
        }
        
        //set initial values for currentuser
        CurrentUser.shared.myLastRecordedLocation = CLLocationCoordinate2D(latitude: thisFeed.lat, longitude: thisFeed.lon)
        
        viewDidLoadCalled = true
        loadPosts()
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //If we have posts available already... reload for new data added
        if viewDidLoadCalled == true {
            loadPosts()
        }
        
        let leftMenu:LeftMenuViewController = SlideNavigationController.sharedInstance().leftMenu as! LeftMenuViewController
        
        leftMenu.populateMenuWithUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Initial Setup
    //------------------------------------------------------------------------------

    func initialSetup() {
        
        initLocationManager()
        initHeaderView()
        initTableView()
        
        initSortByType()
        initPostButton()
        initNoPostsLabel()
        
        //initLocationTestView()
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = K.NumberConstant.Map.DistanceFilter
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func initHeaderView() {
        headerHero.populate(model: thisFeed, index: 0, inFeedMenu: false)
        headerHero.delegate = self
    }
    
    func initTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        
        initSizingCell()
        
        let topOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
        
        postsTable.contentInset = UIEdgeInsetsMake(topOffset, 0, topOffset, 0)
        
        postsTable.register(UINib(nibName: K.NIBName.PostFeedCell, bundle: nil), forCellReuseIdentifier: K.ReuseID.PostFeedCellID)
        
        postsTable.separatorStyle = .none
    }
    
    func initSortByType() {
        sortButton.updateType()
        sortButton.delegate = self
    }
    
    func initPostButton() {
        postButton.setTitle(K.String.Button.Post.localized, for: .normal)
        postButton.addTarget(self, action: #selector(postDidTouch), for: .touchUpInside)
        
        view.bringSubview(toFront: postButton)
    }
    
    func initNoPostsLabel() {
        noPostsLabel.text = K.String.Post.NoPostsLabel.localized
    }
    
    func initSizingCell() {
        sizingCell = UIView.instanceFromNib(name: K.NIBName.PostFeedCell) as? PostFeedCell
    }
    
    func initLocationTestView() {
        
        COORDINATE_TEST_VIEW = UILabel(frame: CGRect(x:20, y:200, width:K.Screen.Width - 40, height:60))
        COORDINATE_TEST_VIEW.backgroundColor = K.Color.localityMapAccent
        COORDINATE_TEST_VIEW.textColor = .white
        COORDINATE_TEST_VIEW.numberOfLines = 2
        COORDINATE_TEST_VIEW.lineBreakMode = .byWordWrapping
        COORDINATE_TEST_VIEW.textAlignment = .center
        
        view.addSubview(COORDINATE_TEST_VIEW)
        
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Data & API
    //------------------------------------------------------------------------------
    
    func loadPosts() {
        GeoFireManager.getPostLocations(range: thisFeed.range, location: CLLocation(latitude:thisFeed.lat, longitude:thisFeed.lon)) { (matched, error) in
            
            if error == nil {
                FirebaseManager.loadFeedPosts(postIDs: matched!,
                                              orderedBy: CurrentUser.shared.sortByType,
                                              completionHandler: { (matchedPosts, error) in
                self.posts.removeAll()
                self.posts = matchedPosts!
                self.postsTable.reloadData()
                
                self.noPostsLabel.isHidden = !self.posts.isEmpty
                
               })
            }
            
        }
    }
    
    func deletePostFromList(thisPost:UserPost, indexPath:IndexPath) {
        
        FirebaseManager.delete(post: thisPost) { (error) in
            if error == nil {
                self.posts.remove(at: indexPath.row)
                self.postsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func blockPostFromList(thisPost:UserPost, indexPath:IndexPath) {
        FirebaseManager.blockPost(pid: thisPost.postId) { (blockedPosts, error) in
            
            if error == nil {
                thisPost.blockedBy = blockedPosts!
                self.posts.remove(at: indexPath.row)
                self.postsTable.deleteRows(at: [indexPath], with: .automatic)
                
                if blockedPosts?.count == K.NumberConstant.BlockedByLimit {
                    FirebaseManager.delete(post: thisPost) { (error) in
                        if error == nil {
                            print("Post deleted from too many blocks!")
                        }
                    }
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: - CTA Methods
    //------------------------------------------------------------------------------
    
    func postDidTouch(sender:UIButton) {
        let newVC:PostCreateViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.PostCreate) as! PostCreateViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - CLLocationManagerDelegate Methods
    //------------------------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CurrentUser.shared.myLastRecordedLocation = locations[0].coordinate
        
        if isMyCurrentLocation == true {
            CurrentUser.shared.currentLocationFeed.lat = locations[0].coordinate.latitude
            CurrentUser.shared.currentLocationFeed.lon = locations[0].coordinate.longitude
        }
        
        //showTestLocation(locations[0].coordinate)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Methods
    //------------------------------------------------------------------------------
    
    func heightForCellAtIndexPath(indexPath:IndexPath) -> CGFloat {
       
        if sizingCell == nil {
            initSizingCell()
        }
        
        let p:UserPost = posts[indexPath.row]
        let imgHeight:CGFloat = p.postImageUrl.isEmpty == true ? 0 : K.Screen.Width * K.NumberConstant.Post.ImageRatio
        
        return sizingCell!.postContent.getViewHeight(caption: p.caption) + imgHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate Methods
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PostFeedCell = tableView.dequeueReusableCell(withIdentifier: K.ReuseID.PostFeedCellID, for: indexPath) as! PostFeedCell
        
        cell.populate(model: posts[indexPath.row])
        
        if cell.thisModel.userHandle == CurrentUser.shared.uid {
            cell.setRightUtilityButtons(rightButtonsMe() as [Any]!, withButtonWidth: K.NumberConstant.SwipeableButtonWidth)
            cell.delegate = self
        }
            
        else {
            cell.setRightUtilityButtons(rightButtons() as [Any]!, withButtonWidth: K.NumberConstant.SwipeableButtonWidth)
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newVC:PostDetailViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.PostDetail) as! PostDetailViewController
        
        newVC.thisPost = posts[indexPath.row]
        navigationController?.pushViewController(newVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heightForCellAtIndexPath(indexPath: indexPath)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UIScrollViewDelegate Methods
    //------------------------------------------------------------------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let collapseH = K.NumberConstant.Header.HeroCollapseHeight
        let expandH = K.NumberConstant.Header.HeroExpandHeight - 20
        
        flexHeaderHeight.constant = max( collapseH, collapseH + (expandH - collapseH + 20) * -(postsTable.contentOffset.y/headerExpandedOffset) - 20)
        
        headerHero.setNeedsUpdateConstraints()
        headerHero.updateHeaderHeight(newHeight: flexHeaderHeight.constant)
        
    }
    
    //------------------------------------------------------------------------------
    // MARK: - SortButtonDelegate Methods
    //------------------------------------------------------------------------------
    
    func sortByTypeDidUpdate(type: SortByType) {
        
        CurrentUser.shared.sortByType = type
        loadPosts()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - SWTableViewCellDelegate Methods
    //------------------------------------------------------------------------------
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        
        let thisCell = cell as! PostFeedCell
        let cellIndexPath:IndexPath = postsTable.indexPath(for: thisCell)!
        
        if thisCell.thisModel.userHandle == CurrentUser.shared.uid {
            //delete
            deletePostFromList(thisPost: thisCell.thisModel, indexPath: cellIndexPath)
        }
        
        else {
            //block
            blockPostFromList(thisPost: thisCell.thisModel, indexPath: cellIndexPath)
        }
        
        thisCell.hideUtilityButtons(animated: true)
    }
    
    func swipeableTableViewCellShouldHideUtilityButtons(onSwipe cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    //------------------------------------------------------------------------------
    // MARK: - SWTableViewCell Helpers
    //------------------------------------------------------------------------------
    
    func rightButtonsMe() -> [Any] {
        let rightUtilityButtons = NSMutableArray()
        
        rightUtilityButtons.sw_addUtilityButton(with: K.Color.swipeDeletRow, icon:UIImage(named:K.Image.DeleteRow))
        
        return rightUtilityButtons.copy() as! [Any]
    }
    
    func rightButtons() -> [Any] {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButton(with: K.Color.swipeReportRow, icon:UIImage(named:K.Image.ReportRow))
        
        return rightUtilityButtons.copy() as! [Any]
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Helpers
    //------------------------------------------------------------------------------
    
    func showTestLocation(_ loc:CLLocationCoordinate2D) {
        COORDINATE_TEST_VIEW.text = "\(loc.latitude, loc.longitude)"
        
    }

}
