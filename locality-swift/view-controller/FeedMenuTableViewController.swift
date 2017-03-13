//
//  FeedMenuTableViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/12/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedMenuTableViewController: UITableViewController, LocalityHeaderViewDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var addNewCell:FeedAddNewCell!
    var menuOptions:[FeedLocation] = [FeedLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initMenuOptions(current: CurrentUser.shared.currentLocation,
                        pinned: CurrentUser.shared.pinnedLocations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTableView() {
        tableView.register(UINib(nibName: K.NIBName.FeedMenuCell, bundle: nil),
                           forCellReuseIdentifier: K.ReuseID.FeedMenuCellID)
        
        tableView.register(UINib(nibName: K.NIBName.FeedAddNewCell, bundle: nil),
                           forCellReuseIdentifier: K.ReuseID.FeedAddNewCellID)
        
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    
    func initMenuOptions(current:FeedLocation, pinned:[FeedLocation]) {
        
        menuOptions.removeAll()
        menuOptions.append(current)
        
        for pin in pinned {
            menuOptions.append(pin)
        }
        
        tableView.reloadData()
    }

    // MARK: - LocalityHeaderViewDelegate
    func openFeedTapped(model: FeedLocation, index: Int) {
        let newVC:FeedViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.Feed) as! FeedViewController
        
        newVC.thisFeed = model
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func iconTapped(btn: HeaderIconButton) {
        
        if btn.iconType == .settings {
            let newVC:FeedSettingsViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.FeedSettings) as! FeedSettingsViewController
            
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return menuOptions.count
        }
        
        else {
            return 1
        }
        
    }

    // MARK: - UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return K.NumberConstant.Header.HeroExpandHeight
        }
            
        else {
            return K.NumberConstant.Feed.AddNewCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let menuCell:FeedMenuCell = tableView.dequeueReusableCell(withIdentifier: K.ReuseID.FeedMenuCellID, for: indexPath) as! FeedMenuCell
            
            menuCell.populate(feed: menuOptions[indexPath.row])
            menuCell.heroView.delegate = self
            
            return menuCell
        }

        else {
            let addNewCell:FeedAddNewCell = tableView.dequeueReusableCell(withIdentifier: K.ReuseID.FeedAddNewCellID, for: indexPath) as! FeedAddNewCell
            
            return addNewCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let newVC:FeedSettingsViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.FeedSettings) as! FeedSettingsViewController
            
            SlideNavigationController.sharedInstance().pushViewController(newVC, animated: true)
        }
    }
}
