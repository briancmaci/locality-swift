//
//  FeedViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedViewController: LocalityBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerContainer:UIView!
    @IBOutlet weak var postsTable:UITableView!
    @IBOutlet weak var flexHeaderHeight:NSLayoutConstraint!
    
    var thisFeed:FeedLocation!
    
    var header:FlexibleFeedHeaderView!
    var sortType:SortByType!
    
    var posts:[UserPost]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSortByType()
        initHeaderView()
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initSortByType() {
        sortType = .proximity
    }
    
    func initHeaderView() {
        
        header = UIView.instanceFromNib(name: K.NIBName.FlexibleFeedHeaderView) as! FlexibleFeedHeaderView
        
        header.frame = CGRect(origin: CGPoint.zero, size: headerContainer.frame.size)
        headerContainer.addSubview(header)
        
        header.populate(model: thisFeed, index: 0, inFeedMenu: false)
        header.delegate = self
    }
    
    func initTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        
        let topOffset = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
        
        postsTable.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0)
        
        postsTable.register(PostFeedCell.self, forCellReuseIdentifier: K.ReuseID.PostFeedCell)
    }
}
