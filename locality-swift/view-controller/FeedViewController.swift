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

class FeedViewController: LocalityBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SortButtonDelegate, SWTableViewCellDelegate {

    let headerExpandedOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
    
    @IBOutlet weak var headerHero:FlexibleFeedHeaderView!
    @IBOutlet weak var postsTable:UITableView!
    @IBOutlet weak var flexHeaderHeight:NSLayoutConstraint!
    @IBOutlet weak var sortButton:SortButtonWithPopup!
    @IBOutlet weak var postButton:UIButton!
    
    @IBOutlet weak var noPostsLabel:UILabel!
    
    var thisFeed:FeedLocation!
    var sortType:SortByType!
    
    var posts:[UserPost] = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CurrentUser.shared.currentFeedLocation = CLLocationCoordinate2D(latitude: thisFeed.lat, longitude: thisFeed.lon)
        
        viewDidLoadCalled = true
        loadPosts()
        
        // Do any additional setup after loading the view.
        initSortByType()
        initPostButton()
        initNoPostsLabel()
        initHeaderView()
        initTableView()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func initNoPostsLabel() {
        noPostsLabel.text = K.String.Post.NoPostsLabel.localized
    }
    
    func initSortByType() {
        sortType = .proximity
        
        sortButton.delegate = self
    }
    
    func initPostButton() {
        postButton.setTitle(K.String.Button.Post.localized, for: .normal)
        postButton.addTarget(self, action: #selector(postDidTouch), for: .touchUpInside)
        
        view.bringSubview(toFront: postButton)
    }
    
    func initHeaderView() {
        headerHero.populate(model: thisFeed, index: 0, inFeedMenu: false)
        headerHero.delegate = self
    }
    
    func initTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        
        let topOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
        
        postsTable.contentInset = UIEdgeInsetsMake(topOffset, 0, topOffset, 0)
        
        postsTable.register(PostFeedCell.self, forCellReuseIdentifier: K.ReuseID.PostFeedCellID)
        
        postsTable.separatorStyle = .none
    }
    
    func postDidTouch(sender:UIButton) {
        let newVC:PostCreateViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.PostCreate) as! PostCreateViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func heightForCellAtIndexPath(indexPath:IndexPath) -> CGFloat {
        var sizingCell:PostFeedCell? = nil
        //DispatchQueue.once {
            sizingCell = PostFeedCell(model: posts[indexPath.row])
        //}
        let p:UserPost = posts[indexPath.row]
        let imgHeight:CGFloat = p.postImageUrl.isEmpty == true ? 0 : K.Screen.Width * K.NumberConstant.Post.ImageRatio
        
        return sizingCell!.postContent.getViewHeight(caption: p.caption) + imgHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //for ease of reading
        let collapseH = K.NumberConstant.Header.HeroCollapseHeight
        let expandH = K.NumberConstant.Header.HeroExpandHeight - 20
        
        flexHeaderHeight.constant = max( collapseH, collapseH + (expandH - collapseH + 20) * -(postsTable.contentOffset.y/headerExpandedOffset) - 20)
        
        headerHero.setNeedsUpdateConstraints()
        headerHero.updateHeaderHeight(newHeight: flexHeaderHeight.constant)
        
    }
    
    //MARK: - SortButtonDelegate Methods
    func sortByTypeDidUpdate(type: SortByType) {
        CurrentUser.shared.sortByType = type
        
        //reload posts and table
        loadPosts()
    }
    
    //MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:PostFeedCell = PostFeedCell(model: posts[indexPath.row])
        
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
        
        //deselect
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heightForCellAtIndexPath(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - SWTableViewCellDelegate Methods
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
    
    func deletePostFromList(thisPost:UserPost, indexPath:IndexPath) {
        
        //Update arrays
        FirebaseManager.delete(post: thisPost) { (error) in
            if error == nil {
                print("Post Deleted!")
                self.posts.remove(at: indexPath.row)
                self.postsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func blockPostFromList(thisPost:UserPost, indexPath:IndexPath) {
        FirebaseManager.blockPost(pid: thisPost.postId) { (blockedPosts, error) in
            
            if error == nil {
                print("Post Blocked!")
                thisPost.blockedBy = blockedPosts!
                self.posts.remove(at: indexPath.row)
                self.postsTable.deleteRows(at: [indexPath], with: .automatic)
                
                if blockedPosts?.count == K.NumberConstant.BlockedByLimit {
                    //remove post
                    FirebaseManager.delete(post: thisPost) { (error) in
                        if error == nil {
                            print("Post deleted from too many blocks!")
                        }
                    }
                }
            }
        }
    }

}
