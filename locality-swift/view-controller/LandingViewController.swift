//
//  LandingViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LandingViewController: LocalityBaseViewController, AngledButtonPairDelegate {

    @IBOutlet weak var exploreButton : RoundedRectangleButton!
    @IBOutlet weak var joinLoginButtonPairView : AngledButtonPairView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        
        //AppUtilities.printFonts()
        
        exploreButton.setAttributes(title:K.Title.Button.LandingExplore,
                                    titleColor:K.Color.landingButtonGray,
                                    backgroundColor:.white)
        exploreButton.addTarget(self, action: #selector(exploreButtonDidTouch), for: .touchUpInside)
        
        let leftAttributes:AngledButtonAttributes = AngledButtonAttributes(title:K.Title.Button.LandingJoin,
                                                                           titleColor:.white,
                                                                           backgroundColor:K.Color.localityBlue)
        
        let rightAttributes:AngledButtonAttributes = AngledButtonAttributes(title:K.Title.Button.LandingLogin,
                                                                            titleColor:K.Color.localityBlue,
                                                                            backgroundColor:K.Color.localityLightBlue)
        
        joinLoginButtonPairView.setAttributesAndBuild(left: leftAttributes, right: rightAttributes)
        joinLoginButtonPairView.delegate = self
    }
    
    func exploreButtonDidTouch(sender:RoundedRectangleButton) {
        print("Explore button touched")
    }
    
    //MARK - AngledButtonPairDelegate
    func leftButtonDidTouch() {
        print("Join button touched")
    }
    
    func rightButtonDidTouch() {
        let newVC : LoginViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.Login) as! LoginViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
