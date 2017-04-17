//
//  FeedViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import AFNetworking
import Mapbox
import SWTableViewCell

class FeedViewController: LocalityBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SortButtonDelegate, SWTableViewCellDelegate, CLLocationManagerDelegate, PostFeedCellDelegate {

    @IBOutlet weak var headerHero: FlexibleFeedHeaderView!
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var flexHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var sortButton: SortButtonWithPopup!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var noPostsLabel: UILabel!
    
    //For Post toggle
    @IBOutlet weak var postButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var postButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var sortButtonCenterOffset: NSLayoutConstraint!
    
    let headerExpandedOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
    
    var refresh: LocalityRefreshControl!
    var refreshTimer: Timer!
    
    var postButtonWidth0: CGFloat!
    var sortButtonOffset0: CGFloat!
    
    var deletePostObject: [String:AnyObject] = [:]
    
    var thisFeed: FeedLocation!
    var isMyCurrentLocation = false //We ALWAYS want to update the feed current location
    
    //DataSource
    var posts: [UserPost] = []
    
    //Updating location constantly
    var locationManager: CLLocationManager!
    
    var sizingCell: PostFeedCell!
    
    var COORDINATE_TEST_VIEW: UILabel!
    
    //------------------------------------------------------------------------------
    // MARK: - View Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //start pushing fcm device id
        
        if UIApplication.shared.isRegisteredForRemoteNotifications == true {
            PushNotificationManager.shared.connectToFcm()
        } else {
            PushNotificationManager.registerForRemoteNotifications()
        }
        
        if thisFeed == CurrentUser.shared.currentLocationFeed {
                isMyCurrentLocation = true
        }
        
        //set initial values for currentuser
        CurrentUser.shared.myLastRecordedLocation = CLLocationCoordinate2D(latitude: thisFeed.lat, longitude: thisFeed.lon)
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if AFNetworkReachabilityManager.shared().isReachable == true {
            loadPosts()
        } else {
            showAlertView(title: K.String.Alert.Title.Network.localized,
                          message: K.String.Alert.Message.Network.localized,
                          close: K.String.Alert.Close.OK.localized,
                          action: K.String.Alert.Action.Retry.localized)
        }
        
        if refresh != nil {
            refresh.animate(true)
        }
        
        let leftMenu: LeftMenuViewController = SlideNavigationController.sharedInstance().leftMenu as! LeftMenuViewController
        
        leftMenu.populateMenuWithUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation()
        refresh.animate(false)
        invalidateRefreshTimer()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Initial Setup
    //------------------------------------------------------------------------------

    func initialSetup() {
        
        //Pull To Refresh
        initRefreshControl()
        
        //This goes first to get initial button size
        initPostButton()
        
        initLocationManager()
        initHeaderView()
        initTableView()
        
        initSortByType()
        initNoPostsLabel()
        
        //initLocationTestView()
    }
    
    func initRefreshControl() {
        
        refresh = LocalityRefreshControl(frame: UIRefreshControl().bounds)
        refresh.create()
        
        postsTable.refreshControl = refresh
        
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
    func scheduleRefreshTimer() {
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: CurrentUser.shared.updateInterval, repeats: false, block: { (timer) in
            self.onRefreshTimerFired(sender: timer)
        })
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
        
        //set constraints
        postButtonWidth0 = postButtonWidth.constant
        sortButtonOffset0 = sortButtonCenterOffset.constant
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
        
        invalidateRefreshTimer()
        
        GeoFireManager.getPostLocations(range: thisFeed.range, location: CLLocation(latitude: thisFeed.lat, longitude: thisFeed.lon)) { (matched, error) in
            
            if error == nil {
                
                //TODO: - LOOK INTO THIS MORE LOOK INTO THIS MORE!!!!
                
//                FirebaseManager.loadFeedPosts(postIDs: matched!, orderedBy: CurrentUser.shared.sortByType, completionHandler: { (matchedPosts, error) in
                
                FirebaseManager.loadFirebaseMatchedPosts(postIDs: matched!, orderedBy: CurrentUser.shared.sortByType, completionHandler: { (matchedPosts, error) in
                    
                    if error == nil {
                        self.posts.removeAll()
                        self.posts = matchedPosts!
                        self.postsTable.reloadData()
                        
                        self.noPostsLabel.isHidden = !self.posts.isEmpty
                    } else {
                        
                        let e = error! as NSError
                        if e.code == K.NumberConstant.TimeoutErrorCode {
                            self.alertTimeout()
                        }
                    }
                    
                    self.refresh.endRefreshing()
                    
                    //startTimer
                    self.scheduleRefreshTimer()
               })
            }
        }
    }
    
    func deletePostFromList(thisPost: UserPost, indexPath: IndexPath) {
        
        FirebaseManager.delete(post: thisPost) { (error) in
            if error == nil {
                self.posts.remove(at: indexPath.row)
                self.postsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func blockPostFromList(thisPost: UserPost, indexPath: IndexPath) {
        
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
    
    func postDidTouch(sender: UIButton) {
        
        let vc = PostCreateViewController(nibName: K.NIBName.VC.PostCreate, bundle: nil)
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
    }
    
    func onRefresh(sender: UIRefreshControl) {
        
        refresh.beginRefreshing()
        loadPosts()
    }
    
    func onRefreshTimerFired(sender: Timer) {
        
        invalidateRefreshTimer()
        loadPosts()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - AlertViewDelegate Methods
    //------------------------------------------------------------------------------
    
    override func tappedAction() {
        
        if alertView.alertId == K.String.Alert.Title.Network.localized {
            loadPosts()
        } else if alertView.alertId == K.String.Alert.Title.DeletePost.localized {
            deletePostFromList(thisPost: deletePostObject["post"] as! UserPost,
                               indexPath: deletePostObject["path"] as! IndexPath)
        }
        
        alertView.closeAlert()
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
        
        checkProximity()
        //showTestLocation(locations[0].coordinate)
    }
    
    func checkProximity() {
        
        //Test if we are in range
        if Util.distanceFrom(lat: thisFeed.lat, lon: thisFeed.lon) < Util.radiusInMeters(range: thisFeed.range) {
            updatePostSortButtons(inRange: true)
        } else {
            updatePostSortButtons(inRange: false)
        }
    }
    
    func updatePostSortButtons(inRange: Bool) {
    
        if inRange == true {
            postButtonWidth.constant = postButtonWidth0
            postButtonHeight.constant = postButtonWidth0
            sortButtonCenterOffset.constant = sortButtonOffset0
        } else {
            postButtonWidth.constant = 0
            postButtonHeight.constant = 0
            sortButtonCenterOffset.constant = 0
        }
        
        view.setNeedsUpdateConstraints()
    }
    
    //------------------------------------------------------------------------------
    // MARK: - PostFeedCellDelegate Methods
    //---------------------------------------------------------------x---------------

    func gotoPost(post: UserPost) {
        
        let vc = PostDetailViewController(nibName: K.NIBName.VC.PostDetail, bundle: nil)
        vc.thisPost = post
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Methods
    //------------------------------------------------------------------------------
    
    func heightForCellAtIndexPath(indexPath: IndexPath) -> CGFloat {
       
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
        cell.postDelegate = self
        
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
        
        let vc = PostDetailViewController(nibName: K.NIBName.VC.PostDetail, bundle: nil)
        vc.thisPost = posts[indexPath.row]
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
        
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
        
        flexHeaderHeight.constant = max(collapseH, collapseH + (expandH - collapseH + 20) * -(postsTable.contentOffset.y/headerExpandedOffset) - 20)
        
        if flexHeaderHeight.constant > K.NumberConstant.Header.HeroExpandHeight {
            flexHeaderHeight.constant = K.NumberConstant.Header.HeroExpandHeight
        }
        
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
            alertDelete(post: thisCell.thisModel, path: cellIndexPath)
            
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
    
    func alertDelete(post: UserPost, path: IndexPath) {
        
        //set delete object
        deletePostObject.removeAll()
        deletePostObject["post"] = post
        deletePostObject["path"] = path as AnyObject?
        
        showAlertView(title: K.String.Alert.Title.DeletePost.localized,
                      message: K.String.Alert.Message.DeletePost.localized,
                      close: K.String.Alert.Close.No.localized,
                      action: K.String.Alert.Action.Yes.localized)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - SWTableViewCell Helpers
    //------------------------------------------------------------------------------
    
    func rightButtonsMe() -> [Any] {
        let rightUtilityButtons = NSMutableArray()
        
        rightUtilityButtons.sw_addUtilityButton(with: K.Color.swipeDeletRow,
                                                icon: UIImage(named:K.Image.DeleteRow))
        
        return rightUtilityButtons.copy() as! [Any]
    }
    
    func rightButtons() -> [Any] {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButton(with: K.Color.swipeReportRow,
                                                icon: UIImage(named:K.Image.ReportRow))
        
        return rightUtilityButtons.copy() as! [Any]
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Helpers
    //------------------------------------------------------------------------------
    
    func invalidateRefreshTimer() {
        
        if refreshTimer != nil {
            refreshTimer.invalidate()
            refreshTimer = nil
        }
    }
    
    func showTestLocation(_ loc: CLLocationCoordinate2D) {
        
        COORDINATE_TEST_VIEW.text = "\(loc.latitude, loc.longitude)"
    }

}
