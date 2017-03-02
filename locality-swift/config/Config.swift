//
//  Config.swift
//  locality-swift
//
//  Created by Chelsea Power on 2/28/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

//Constants
struct K {
    
    //API Keys
    struct APIKey {
        
    }
    
    //Back End URLs
    struct BackEndURL {
        
    }
    
    //Back End Params
    struct Param {
        
    }
    
    struct Screen {
        static let Width = UIScreen.main.bounds.size.width
        static let Height = UIScreen.main.bounds.size.height
    }
    
    //Colors
    struct Color {
        static let landingButtonGray = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        static let localityBlue = UIColor(red: 41/255, green: 64/255, blue: 82/255, alpha: 1)
        static let localityLightBlue = UIColor(red: 199/255, green: 221/255, blue: 237/255, alpha: 1)
        
    }
    
    //All app titles
    struct Title {
        struct Button {
            static let LandingExplore = "EXPLORE LOCALITY"
            static let LandingJoin = "JOIN LOCALITY"
            static let LandingLogin = "LOGIN"
        }
        
        struct ViewController {
            
        }
    }
    
    struct FontName {
        static let InterstateLightCondensed = "Interstate-LightCond"
    }
    
    //Icons
    struct Icon {
        //static let HeaderBarLogo = "HeaderBarLogo"
    }
    
    struct Image {
    }
    
    //Storyboard IDs
    struct Storyboard {
        
        struct Name {
            static let Main = "Main"
        }
        
        struct ID {
            static let Landing = "landingVC"
            static let Login = "loginVC"
        }
    }
    
    //NIB Names
    struct NIBName {
        //static let BottomNavigation = "BottomNavigation"
        
    }
    
    //UITableViewCell reuseIdentifiers
    struct ReuseID {
        
    }
    
    //Strings
    struct StringFormat {
        static let CopyrightVersion = "©%d Locality v%@.%@. All rights reserved."
    }
    
    //Constant numerical values
    struct NumberConstant {
        static let HeaderAndStatusBarsHeight : CGFloat = 64
        
        //Buttons
        static let RoundedButtonCornerRadius : CGFloat = 5
        static let RoundedButtonAngleWidth : CGFloat = 14
    }
}
