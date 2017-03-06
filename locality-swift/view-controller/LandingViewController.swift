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
    
    //Used for button animation
    @IBOutlet weak var joinLoginBottom : NSLayoutConstraint!
    @IBOutlet weak var exploreBottom : NSLayoutConstraint!
    
    var joinLoginY0 : CGFloat!
    var joinLoginY1 : CGFloat!
    var exploreY0 : CGFloat!
    var exploreY1 : CGFloat!
    
    let buttonGap : CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initButtons()
        initButtonAnimation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButtonsIn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        
        //AppUtilities.printFonts()
        exploreButton.setAttributes(title:K.String.Button.LandingExplore.localized,
                                    titleColor:K.Color.landingButtonGray,
                                    backgroundColor:.white)
        
        exploreButton.addTarget(self, action: #selector(exploreButtonDidTouch), for: .touchUpInside)
        
        let leftAttributes:AngledButtonAttributes =
            AngledButtonAttributes(title:K.String.Button.LandingJoin.localized,
                                   titleColor:.white,
                                   backgroundColor:K.Color.localityBlue)
        
        let rightAttributes:AngledButtonAttributes =
            AngledButtonAttributes(title:K.String.Button.LandingLogin.localized,
                                   titleColor:K.Color.localityBlue,
                                   backgroundColor:K.Color.localityLightBlue)
        
        joinLoginButtonPairView.setAttributesAndBuild(left: leftAttributes, right: rightAttributes)
        joinLoginButtonPairView.delegate = self
    }
    
    func initButtonAnimation() {
    
        //init animate-in values
        exploreY0 = -joinLoginButtonPairView.frame.size.height
        exploreY1 = exploreBottom.constant
        
        joinLoginY0 = (exploreY0 * 2) - buttonGap
        joinLoginY1 = joinLoginBottom.constant
        
        exploreBottom.constant = exploreY0
        joinLoginBottom.constant = joinLoginY0
        
        view.layoutIfNeeded()
    }
    
    func animateButtonsIn() {
    
        exploreBottom.constant = exploreY1
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: { self.view.layoutIfNeeded() },
                       completion:nil)
        
        joinLoginBottom.constant = joinLoginY1
        UIView.animate(withDuration: 0.55,
                       delay: 0.1,
                       options: [.curveEaseOut],
                       animations: { self.view.layoutIfNeeded() },
                       completion:nil)
    }
    
    //CTAs
    func exploreButtonDidTouch(sender:RoundedRectangleButton) {
        print("Explore button touched")
    }
    
    //MARK: - AngledButtonPairDelegate
    func leftButtonDidTouch() {
        let newVC : JoinViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.Join) as! JoinViewController
        
        navigationController?.pushViewController(newVC, animated: true)
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
