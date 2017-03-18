//
//  AddCommentCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol AddCommentDelegate {
    func commentToPost(comment:String)
    func addCommentDidCancel()
}

class AddCommentCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var commentField:UITextView!
    @IBOutlet weak var postButton:UIButton!
    @IBOutlet weak var postButtonBottom:NSLayoutConstraint!
    
    var delegate:AddCommentDelegate?
    
    let tablePadding:CGFloat = 20.0
    let postButtonPadding:CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initButtons()
        initKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initButtons() {
        postButton.addTarget(self, action: #selector(postDidTouch), for: .touchUpInside)
    }
    
    // Keyboard Toolbar Create
    func initKeyboard() {
        let cancelToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: K.Screen.Width, height: 30))
        
        cancelToolbar.barStyle       = UIBarStyle.default
        cancelToolbar.barTintColor = K.Color.localityBlue
        
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancel: UIBarButtonItem  = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelButtonAction))
        
        cancel.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: K.FontName.InterstateLightCondensed, size: 14.0)!,
            NSForegroundColorAttributeName: UIColor.white],
                                       for: .normal)

        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(cancel)
        
        cancelToolbar.items = items
        cancelToolbar.sizeToFit()
        
        commentField.inputAccessoryView = cancelToolbar
    }
    
    func cancelButtonAction() {
        commentField.resignFirstResponder()
        
        delegate?.addCommentDidCancel()
    }
    
    func activate() {
        listenForKeyboard(yes: true)
        commentField.text.removeAll()
        commentField.becomeFirstResponder()
    }
    
    func listenForKeyboard(yes:Bool) {
        
        if yes == true {
            NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        }
        
        else {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        }
    }
    
    func onKeyboardShow(notification:Notification) {
        
        listenForKeyboard(yes: false)
        
        let keyboardInfo = notification.userInfo
        
        let keyboardFrameBegin = keyboardInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        
        postButtonBottom.constant = keyboardFrameBeginRect.size.height - K.NumberConstant.Post.DetailFooterHeight + tablePadding + postButtonPadding
        
        layoutIfNeeded()
    }
    
    //CTA
    func postDidTouch(sender:UIButton) {
        delegate?.commentToPost(comment: commentField.text)
    }
}
