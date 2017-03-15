//
//  PostDetailViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostDetailViewController: LocalityBaseViewController, UITableViewDelegate, UITableViewDataSource, AddCommentDelegate {

    var thisPost:UserPost!
    
    @IBOutlet weak var postHeader:PostDetailHeaderView!
    @IBOutlet weak var postHeaderHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var noCommentsLabel:UILabel!
    @IBOutlet weak var commentsTable:UITableView!
    @IBOutlet weak var writeCommentButton:UIButton!
    
    var postComments:[UserComment] = [UserComment]()
    var isAddingComment:Bool = false
    
    var addCommentCell:AddCommentCell!
    var sizingCell:CommentFeedCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeaderView()
        initButtons()
        initNoCommentsLabel()
        initPostDetailHeader()
        initTableView()
        initAddCommentCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadComments()
    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        header.initAttributes(title: K.String.Header.PostDetailHeader.localized,
                              leftType: .back, rightType: .close)
        
        view.addSubview(header)
    }
    
    func initButtons() {
        writeCommentButton.addTarget(self, action: #selector(writeCommentDidTouch), for: .touchUpInside)
    }
    
    func initNoCommentsLabel() {
        noCommentsLabel.text = K.String.Post.NoCommentsLabel.localized
    }
    
    func initTableView() {
        commentsTable.register(UINib(nibName: K.NIBName.CommentFeedCell, bundle: nil), forCellReuseIdentifier: K.ReuseID.CommentFeedCellID)
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        commentsTable.separatorStyle = .none
        
        isAddingComment = false
    }
    
    func initPostDetailHeader() {
        postHeader.populateWithData(model: thisPost)
        postHeader.backgroundColor = .clear
        postHeader.isOpaque = false
    }
    
    func loadComments() {
        print("LOAD COMMENTS >>>>>")
    }
    
    ////MARK : - UITableViewDelegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return postComments.count
        }
        
        else {
            return isAddingComment == true ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return heightForBasicCellAtIndexPath(path:indexPath)
        }
        
        else {
            return commentsTable.frame.size.height
        }
    }
    
    func heightForBasicCellAtIndexPath(path: IndexPath) -> CGFloat {
        sizingCell = CommentFeedCell(comment: postComments[0])
        let c:UserComment = postComments[path.row]
        
        return sizingCell.getViewHeight(txt: c.commentText)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell:UITableViewCell) -> CGFloat {
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size:CGSize = sizingCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        return size.height
    }
    
    func basicCellAtIndexPath(path:IndexPath) -> CommentFeedCell {
        let cell:CommentFeedCell = CommentFeedCell(comment:postComments[path.row])
        
        if path.row == 0 {
            cell.pinline.isHidden = true
        }
        
        else {
            cell.pinline.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return basicCellAtIndexPath(path: indexPath)
        }
        
        else {
            return addCommentCell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Do nothing
    }
    
    func initAddCommentCell() {
        addCommentCell = UIView.instanceFromNib(name: K.NIBName.AddCommentCell) as! AddCommentCell
        addCommentCell.delegate = self
    }
    
    func writeCommentDidTouch(sender:UIButton) {
        addNewCommentCell()
    }
    
    func addNewCommentCell() {
        noCommentsLabel.isHidden = true
        
        commentsTable.contentOffset = CGPoint(x:0, y:tableHeight() - K.NumberConstant.StatusBarHeight)
        
        isAddingComment = true
        
        let newIndexPath:IndexPath = IndexPath(row:0, section:1)
        
        commentsTable.beginUpdates()
        addCommentCell.activate()
        commentsTable.insertRows(at: [newIndexPath], with: .bottom)
        commentsTable.endUpdates()
    }
    
    ////MARK : - AddCommentDelegate Methods
    func commentToPost(comment: String) {
        let newComment:UserComment = UserComment(comment: comment, postId: thisPost.postId, user: CurrentUser.shared)
        
        FirebaseManager.write(comment: newComment) { (success, error) in
            
            if error != nil {
                print("Write comment error: \(error?.localizedDescription)")
            }
            
            else {
                print("Comment written!")
                self.pushNewCommentToTable(comment:newComment)
            }
        }
    }
    
    func pushNewCommentToTable(comment:UserComment) {
        isAddingComment = false
        
        addCommentCell.commentField.resignFirstResponder()
        
        CATransaction.begin()
        commentsTable.beginUpdates()
        
        CATransaction.setCompletionBlock { 
            self.postComments.append(comment)
            let newCommentPath:IndexPath = IndexPath(row: self.postComments.count - 1, section: 0)
            
            self.commentsTable.insertRows(at: [newCommentPath], with: .left)
            
            let c:CommentFeedCell = self.commentsTable.cellForRow(at: newCommentPath) as! CommentFeedCell
            c.popBackground()
            
            self.scrollToBottomOfTableViewWithNewComment(addNew:false, animated:true)
            self.commentsTable.isScrollEnabled = true
        }
        
        let addNewIndexPath:IndexPath = IndexPath(row:0, section:1)
        commentsTable.deleteRows(at: [addNewIndexPath], with: .fade)
        commentsTable.endUpdates()
        CATransaction.commit()
    }
    
    func scrollToBottomOfTableViewWithNewComment(addNew:Bool, animated:Bool) {
        
        let scrollRectY:CGFloat = tableHeight() + (addNew == true ? addCommentCell.bounds.size.height : 0) - commentsTable.bounds.size.height
        
        commentsTable.scrollRectToVisible(CGRect(x:0,
                                                 y:scrollRectY,
                                                 width:commentsTable.bounds.size.width,
                                                 height:commentsTable.bounds.size.height ), animated: animated)
    }
    
    func tableHeight() -> CGFloat {
        var height:CGFloat = 0
        var c:UserComment!
        
        for comment in postComments {
            c = comment 
            height += sizingCell.getViewHeight(txt: c.commentText)
        }
        
        return height
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
