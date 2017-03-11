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
        static let Mapbox = "MapboxAPIKey"
        static let Firebase = "FirebaseDBKey"
    }
    
    //Back End URLs
    struct BackEndURL {
        static let ReverseGeocodeFormat = "https://api.mapbox.com/geocoding/v5/mapbox.places/%.8f,%.8f.json?types=place&access_token=%@"
    }
    
    struct DB {
        static let FirebaseURLFormat = "https://%@.firebaseio.com"
        struct Storage {
            static let Images = "images"
        }
        
        struct Table {
            static let Users = "users"
            static let Posts = "posts"
            static let Comments = "comments"
            
            //GeoFire
            static let PostLocations = "post_locations"
        }
        
        struct Var {
            
            //User
            static let UserId = "uid"
            static let IsFirstVisit = "isFirstVisit"
            static let ProfileImageURL = "profileImageUrl"
            static let Status = "status"
            static let Username = "username"
            static let CurrentLocation = "currentLocation"
            static let Locations = "locations"
            
            //Location
            static let Name = "name"
            static let Location = "location"
            static let FeedImgURL = "feedImgUrl"
            static let Lat = "lat"
            static let Lon = "lon"
            static let Range = "range"
            static let IsCurrentLocation = "isCurrentLocation"
            static let PromotionsEnabled = "promotionsEnabled"
            static let PushEnabled = "pushEnabled"
            static let ImportantEnabled = "importantEnabled"
            
            //Post
            static let User = "User"
            static let CreatedDate = "createdDate"
            static let PostId = "postId"
            //Lat
            //Long
            static let Caption = "caption"
            static let PostImageURL = "postImageUrl"
        }
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
        static let localityMapAccent = UIColor(red: 1, green: 125/255, blue: 108/255, alpha: 1)
        
        static let toggleRed = UIColor(red: 180/255, green: 0, blue: 38/255, alpha: 1)
        static let toggleGray = UIColor(red: 205/255, green: 215/255, blue: 219/255, alpha: 1)
        
    }
    
    struct FontName {
        static let InterstateLightCondensed = "Interstate-LightCondensed"
    }
    
    //Icons
    struct Icon {
        
        struct Header {
            static let Back = "IconBack"
            static let Close = "IconClose"
            static let Hamburger = "IconHamburger"
            static let Settings = "IconSettings"
            static let FeedMenu = "IconFeedMenu"
        }
    }
    
    struct Image {
        static let DefaultAvatarProfile = "DefaultAvatarProfile"
        static let DefaultAvatarProfilePost = "DefaultAvatarProfilePost"
        
        //Feed
        static let DefaultFeedHero = "DefaultFeedHero"
        
        //Location Range Slider
        static let SliderBackground = "SliderBackground"
        static let SliderTickMark = "SliderTickMark"
        static let SliderKnob = "SliderKnob"
    }
    
    //Storyboard IDs
    struct Storyboard {
        
        struct Name {
            static let Main = "Main"
        }
        
        struct ID {
            static let Landing = "landingVC"
            
            static let Login = "loginVC"
            
            static let Join = "joinVC"
            static let JoinUser = "joinUsernameVC"
            static let JoinValidate = "joinValidateVC"
            
            static let CurrentFeedInit = "currentFeedInitVC"
            static let Feed = "feedVC"
            
            static let LeftMenu = "leftMenuVC"
            
            static let PostCreate = "postCreateVC"
            static let PostDetail = "postDetailVC"
        }
    }
    
    struct PList {
        static let Keys = "Keys"
        static let Main = "Main"
        static let RangeValuesFeet = "RangeValuesFeet"
    }
    
    //NIB Names
    struct NIBName {
        static let LocationSlider = "LocationSlider"
        static let FlexibleFeedHeaderView = "FlexibleFeedHeaderView"
        static let PostFeedCellView = "PostFeedCellView"
        static let PostUserInfoView = "PostUserInfoView"
        static let ImageUploadView = "ImageUploadView"
        static let PostFromView = "PostFromView"
        static let CameraOverlay = "CameraOverlay"
    }
    
    //UITableViewCell reuseIdentifiers
    struct ReuseID {
        static let PostFeedCellID = "postFeedCell"
    }
    
    //Strings
    struct String {
        static let CopyrightVersionFormat = "copyright-version-format"
        static let CurrentFeedName = "_current"
        static let HeaderTitleLogo = "logo"
        
        //Buttons
        struct Button {
            static let LandingExplore = "explore-button-label"
            static let LandingJoin = "join-button-label"
            static let LandingLogin = "login-button-label"
        }
        
        struct Header {
            static let CurrentLocationTitle = "current-location-title"
            static let CreatePostHeader = "create-post-header"
        }
        
        struct User {
            static let Anonymous = "username-anonymous"
        }
        
        //UserStatus
        struct UserStatus {
            static let NewUser = "new-user"
            static let Contributor = "contributor"
            static let Reporter = "reporter"
            static let Columnist = "columnist"
            static let TrustedSource = "trusted-source"
        }
        
        struct Mapbox {
            static let CurrentLocationHeader = "current-map-header"
        }
        
        struct UploadURL {
            static let ProfileFormat = "%@/profile"
            static let LocationFormat = "%@/location_%@"
            static let PostFormat = "%@/post_%@"
        }
        
        struct Alert {
            static let VerifyTitle = "alert-verify-title"
            static let VerifyMessage = "alert-verify-message"
            static let VerifyButton0 = "alert-verify-button0"
        }
        
        struct Error {
            static let EmailDuplicate = "email-duplicate"
            static let EmailInUseEmail = "in-use-email"
            static let EmailInUseFacebook = "in-use-facebook"
            static let EmailInvalid = "email-invalid"
            static let EmailEmpty = "email-empty"
            static let PasswordMismatch = "password-mismatch"
            static let PasswordEmpty = "password-empty"
            static let PasswordTooShort = "password-too-short"
            static let PasswordTooWeak = "password-too-weak"
            static let PasswordWrong = "password-wrong"
            static let UserDisabled = "user-disabled"
            static let UsernameTaken = "username-taken"
        }
        
        struct Post {
            static let TimestampFormat = "yyyy-MM-dd HH:mm:ss zzz"
            static let CaptionDefault = "post-caption-default"
            static let CaptionError = "post-caption-error"
        }
    }
    
    //Constant numerical values
    struct NumberConstant {
        static let HeaderAndStatusBarsHeight : CGFloat = 64
        
        //Buttons
        static let RoundedButtonCornerRadius : CGFloat = 5
        static let RoundedButtonAngleWidth : CGFloat = 14
        
        struct Map {
            static let EarthRadius = 6371000.0
            static let DefaultRange = 500.0
        }
        
        struct Header {
            static let HeroExpandHeight:CGFloat = 157.0
            static let HeroCollapseHeight:CGFloat = 59.0
            static let ButtonPadding:CGFloat = 20.0
            static let TitleY0:CGFloat = 30.0
            static let TitleY1:CGFloat = 62.0
            static let TitleHeight:CGFloat = 20.0
            static let FontSize:CGFloat = 18.0
            static let ButtonIndent:CGFloat = 8.0
        }
        
        struct Post {
            static let ImageRatio:CGFloat = 0.5
        }
        
        struct Upload {
            static let ImageQuality:CGFloat = 0.5
        }
    }
    
    //Mapbox Constants
    struct Mapbox {
        static let MapStyle = "mapbox://styles/briancmaci/cizuyqi10001a2so2gpt7i09b"
        
        struct Marker {
            
            struct Image {
                static let Range = "MarkerRange"
            }
            
            struct `Type` {
                static let Range = "Range"
                
            }
        }
    }
}
