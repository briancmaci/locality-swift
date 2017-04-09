//
//  SortButtonWithPopup.swift
//  PopupMenu
//
//  Created by Chelsea Power on 3/18/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol SortButtonDelegate {
    func sortByTypeDidUpdate(type:SortByType)
}

class SortButtonWithPopup: UIView {

    @IBOutlet weak var view:UIView!
    @IBOutlet weak var sortButtonContainer:UIView!
    @IBOutlet weak var sortButtonTrigger:SortButtonView!
    
    var popup:PopupMenuView!
    var popupIsOpen:Bool = false
    
    var delegate:SortButtonDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.SortButtonWithPopup, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        
    }
    
    override func awakeFromNib() {
        initSortTrigger()
        buildPopupMenu()
    }
    
    func initSortTrigger() {
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        
        longPress.minimumPressDuration = 0.2
        //longPress.delegate = self
        sortButtonTrigger.addGestureRecognizer(longPress)
    }
    
    func buildPopupMenu() {
        //add three buttons
        let proximityButton:PopupButtonView = PopupButtonView(type: .proximity)
        let timeButton:PopupButtonView = PopupButtonView(type: .time)
        let activityButton:PopupButtonView = PopupButtonView(type: .activity)
        
        popup = PopupMenuView(btn:[proximityButton, timeButton, activityButton])
        
        var popupFrame = popup.frame
        popupFrame.origin.x = sortButtonTrigger.center.x - kPopButtonWidth/2
        popupFrame.origin.y = -popup.frame.size.height
        popup.frame = popupFrame
        
        sortButtonContainer.addSubview(popup)
        
        popup.isHidden = true
        
    }
    
    func onLongPress(gesture:UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            popupIsOpen = true
            popup.isHidden = false
            
        case .ended, .cancelled, .failed:
            testDidSelect(loc: gesture.location(ofTouch: 0, in: popup))
            popupIsOpen = false
            popup.isHidden = true
            
        case .changed:
            testTouch(loc: gesture.location(ofTouch: 0, in: popup))
            
        default:
            popupIsOpen = false
            popup.isHidden = true
        }
    }
    
    func testTouch(loc:CGPoint) {
        for btn in popup.btns {
            
            if btn.frame.contains(loc) {
                btn.updateStage(on: true)
            }
                
            else {
                btn.updateStage(on:false)
            }
            
        }
    }
    
    func testDidSelect(loc:CGPoint) {
        for btn in popup.btns {
            
            if btn.frame.contains(loc) {
                sortButtonTrigger.updateIcon(type: btn.type)
                delegate?.sortByTypeDidUpdate(type: btn.type)
            }
            
            //reset state
            btn.updateStage(on: false)
        }
    }

    func updateType() {
        sortButtonTrigger.updateIcon(type: CurrentUser.shared.sortByType)
    }
}
