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
        static let GooglePlaces = "GooglePlacesAPIKey"
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
            static let Pinned = "pinned"
            static let NotificationToken = "notificationToken"
            
            //Location
            static let LocationId = "lid"
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
            static let User = "user"
            static let CreatedDate = "createdDate"
            static let PostId = "postId"
            static let LikedBy = "likedBy"
            static let CommentCount = "commentCount"
            static let BlockedBy = "blockedBy"
            static let IsAnonymous = "isAnonymous"
            static let IsImportant = "isImportant"
            //Lat
            //Long
            static let Caption = "caption"
            static let PostImageURL = "postImageUrl"
            
            //Comment
            //UserId
            //PostId
            //CreatedDate
            static let CommentId = "cid"
            static let CommentText = "comment"
            
            //Average Color
            static let AverageColorHex = "avg-img-hex"
        }
    }
    
    struct Push {
        static let TopicBase = "/topics/"
        
        struct Topic {
            static let AllDevices = "all-devices"
            static let UserIdFormat = "uid_%@"
        }
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
        
        static let pullToRefreshColor = UIColor(red: 41/255, green: 64/255, blue: 82/255, alpha: 0.4)
        static let pullToRefreshSpinnerColor = UIColor(red: 41/255, green: 64/255, blue: 82/255, alpha: 0.3)
        
        static let toggleRed = UIColor(red: 180/255, green: 0, blue: 38/255, alpha: 1)
        static let toggleGray = UIColor(red: 205/255, green: 215/255, blue: 219/255, alpha: 1)
        
        static let leftNavSelected = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        static let leftNavLight = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        static let leftNavDark = UIColor(red: 75/255, green: 81/255, blue: 85/255, alpha: 1)
        
        static let postCommentGray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        
        static let commentBackground = UIColor(red: 238/255, green: 238/255, blue:238/255, alpha:1)
        
        //sort
        static let sortBackgroundOff:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        static let sortBackgroundOn:UIColor = UIColor(red: 75/255, green: 82/255, blue: 87/255, alpha: 1)
        static let sortIconOff:UIColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)
        static let sortIconOn:UIColor = .white
        static let sortPin:UIColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        
        //swipe
        static let swipeDeletRow:UIColor = UIColor(red: 74/255, green:45/255, blue:45/255, alpha: 1)
        static let swipeReportRow:UIColor = UIColor(red: 72/255, green:74/255, blue:45/255, alpha: 1)
        
        //averageHex
        static let defaultHex = "CCCCCC"
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
        
        struct Post {
            static let PostCommentIconGray = "IconPostComment"
            static let PostCommentIconWhite = "IconPaperclipWhite"
        }
        
        struct Sort {
            static let Proximity = "ButtonSortProximity"
            static let Time = "ButtonSortTime"
            static let Activity = "ButtonSortActivity"
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
        
        //SwipeToDelete
        static let DeleteRow = "DeleteRow"
        static let ReportRow = "ReportRow"
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
            static let FeedMenu = "feedMenuVC"
            static let FeedSettings = "feedSettingsVC"
            
            static let LeftMenu = "leftMenuVC"
            
            static let PostCreate = "postCreateVC"
            static let PostDetail = "postDetailVC"
            
            static let About = "aboutVC"
            static let Settings = "settingsVC"
        }
    }
    
    struct PList {
        static let Keys = "Keys"
        static let Main = "Main"
        static let MenuOptions = "MenuOptions"
        static let FeedOptions = "FeedOptions"
        static let RangeValuesFeet = "RangeValuesFeet"
    }
    
    //NIB Names
    struct NIBName {
        
        struct VC {
            static let Landing = "LandingViewController"
            
            static let Join = "JoinViewController"
            static let JoinUser = "JoinUsernameViewController"
            static let JoinValidate = "JoinValidateViewController"
            static let Login = "LoginViewController"
            
            static let CurrentFeedInit = "CurrentFeedInitializeViewController"
            static let Feed = "FeedViewController"
            static let FeedMenu = "FeedMenuTableViewController"
            static let FeedSettings = "FeedSettingsViewController"
            
            static let About = "AboutViewController"
            static let Settings = "SettingsViewController"
            
            static let PostCreate = "PostCreateViewController"
            static let PostDetail = "PostDetailViewController"
            
            static let LeftMenu = "LeftMenuViewController"
            
            static let ForgotPassword = "ForgotPasswordViewController"
            
        }
        
        static let LocationSlider = "LocationSlider"
        static let FlexibleFeedHeaderView = "FlexibleFeedHeaderView"
        static let PostFeedCell = "PostFeedCell"
        static let PostFeedCellView = "PostFeedCellView"
        static let PostUserInfoView = "PostUserInfoView"
        static let ImageUploadView = "ImageUploadView"
        static let PostFromView = "PostFromView"
        static let CameraOverlay = "CameraOverlay"
        static let PostDetailHeaderView = "PostDetailHeaderView"
        static let LeftMenuCell = "LeftMenuCell"
        
        static let FeedAddNewCell = "FeedAddNewCell"
        static let FeedMenuCell = "FeedMenuCell"
        static let FeedSettingsToggleCell = "FeedSettingsToggleCell"
        
        static let CommentFeedCell = "CommentFeedCell"
        static let AddCommentCell = "AddCommentCell"
        
        static let SortButtonWithPopup = "SortButtonWithPopup"
    }
    
    //UITableViewCell reuseIdentifiers
    struct ReuseID {
        static let PostFeedCellID = "postFeedCell"
        static let LeftMenuCellID = "leftMenuCell"
        static let FeedAddNewCellID = "feedAddNewCell"
        static let FeedMenuCellID = "feedMenuCell"
        static let FeedSettingsToggleCellID = "feedSettingsToggleCell"
        static let PlacesSearchCellID = "GMSPlacesAutocompleteCell"
        static let CommentFeedCellID = "commentFeedCell"
        static let AddCommentCellID = "addCommentCell"
    }
    
    //Strings
    struct String {
        static let CopyrightVersionFormat = "copyright-version-format"
        static let CurrentFeedName = "_current"
        static let HeaderTitleLogo = "logo"
        
        static let ContactEmailAddress = "support@locality.com"
        
        //Alerts
        struct Alert {
            struct Title {
                static let Network = "alert-network-title"
                static let Timeout = "alert-timeout-title"
                static let Verify = "alert-verify-title"
                static let Logout = "alert-logout-title"
                static let Contact = "alert-contact-title"
                static let DeleteAccount = "alert-delete-account-title"
                static let DeleteLocation = "alert-delete-location-title"
                static let DeletePost = "alert-delete-post-title"
            }
            
            struct Message {
                static let Network = "alert-network-message"
                static let Timeout = "alert-timeout-message"
                static let Verify = "alert-verify-message"
                static let Logout = "alert-logout-message"
                static let Contact = "alert-contact-message"
                static let DeleteAccount = "alert-delete-account-title"
                static let DeleteLocation = "alert-delete-location-message"
                static let DeletePost = "alert-delete-post-message"
            }
            
            struct Close {
                static let OK = "alert-close-okay"
                static let No = "alert-close-no"
            }
            
            struct Action {
                static let Retry = "alert-action-retry"
                static let Yes = "alert-action-yes"
                static let Resend = "alert-action-resend"
            }
        }
        
        //Buttons
        struct Button {
            static let LandingExplore = "explore-button-label"
            static let LandingJoin = "join-button-label"
            static let LandingLogin = "login-button-label"
            static let Terms = "terms-label"
            static let Post = "button-post-label"
            static let Sort = "button-sort-label"
        }
        
        struct Header {
            static let CurrentLocationTitle = "current-location-title"
            static let CreatePostHeader = "create-post-header"
            static let PostDetailHeader = "post-detail-header"
            static let AddNewLocationHeader = "add-new-location-header"
            static let EditLocationHeader = "edit-location-header"
        }
        
        struct Feed {
            static let AddFeedLabel = "add-feed-label"
            static let SaveFeedLabel = "save-feed-label"
            static let UpdateFeedLabel = "update-feed-label"
            static let DeleteFeedLabel = "delete-feed-label"
            static let FeedNameDefault = "feed-name-default"
            static let FeedNameError = "feed-name-error"
            
            //settings
            struct Setting {
                static let PushEnabled = "pushEnabled"
                static let PromotionsEnabled = "promotionsEnabled"
            }
        }
        
        struct User {
            static let Anonymous = "username-anonymous"
            static let Me = "username-me"
        }
        
        //UserStatus
        struct UserStatus {
            static let NewUser = "new-user"
            static let Contributor = "contributor"
            static let Reporter = "reporter"
            static let Columnist = "columnist"
            static let TrustedSource = "trusted-source"
        }
        
        struct Menu {
            struct Action{
                static let Segue = "ViewSegue"
                static let Action = "Action"
            }
            
            struct Style {
                static let Light = "light"
                static let Dark = "dark"
            }
            
            static let LikesOneFormat = "likes-one-format"
            static let LikesMultiFormat = "likes-multi-format"
            static let PostsOneFormat = "posts-one-format"
            static let PostsMultiFormat = "posts-multi-format"
        }
        
        struct Mapbox {
            static let CurrentLocationHeader = "current-map-header"
        }
        
        struct UploadURL {
            static let ProfileFormat = "%@/profile"
            static let LocationFormat = "%@/location_%@"
            static let PostFormat = "%@/post_%@"
        }
        
        struct Error {
            static let EmailDuplicate = "email-duplicate"
            static let EmailInUseEmail = "in-use-email"
            static let EmailInUseFacebook = "in-use-facebook"
            static let EmailInvalid = "email-invalid"
            static let NoSuchEmail = "no-such-email"
            static let EmailEmpty = "email-empty"
            static let PasswordMismatch = "password-mismatch"
            static let PasswordEmpty = "password-empty"
            static let PasswordTooShort = "password-too-short"
            static let PasswordTooWeak = "password-too-weak"
            static let PasswordWrong = "password-wrong"
            static let UserDisabled = "user-disabled"
            static let UsernameTaken = "username-taken"
            static let UsernameEmpty = "username-empty"
            static let UsernameTooShort = "username-too-short"
            static let SomethingWentWrong = "something-went-wrong"
        }
        
        struct Post {
            static let TimestampFormat = "yyyy-MM-dd HH:mm:ss zzz"
            static let CaptionDefault = "post-caption-default"
            static let CaptionError = "post-caption-error"
            static let NoPostsLabel = "no-posts-label"
            static let NoCommentsLabel = "no-comments-label"
        }
        
        struct About {
            static let AboutCopy = "about-copy"
            static let AboutShareLabel = "about-share-label"
        }
        
        struct Cropper {
            static let TitleLabel = "cropper-title"
            static let CancelLabel = "cropper-cancel-label"
            static let ChooseLabel = "cropper-choose-label"
        }
        
        struct Login {
            static let ForgotPasswordLabel = "forgot-password-label"
            static let EmailSentLabel = "email-sent-label"
        }
        
        struct Username {
            static let UsernameChangedLabel = "username-changed-label"
        }
    }
    
    //Constant numerical values
    struct NumberConstant {
        static let HeaderAndStatusBarsHeight: CGFloat = 64
        static let StatusBarHeight: CGFloat = 20
        
        static let RangeMaximumInMeters: CGFloat = 16093.4
        
        static let SwipeableButtonWidth: CGFloat = 44
        
        static let BlockedByLimit: Int = 5
        
        static let TimeoutInterval: TimeInterval = 30
        static let TimeoutErrorCode: Int = 666999
        
        //Buttons
        static let RoundedButtonCornerRadius: CGFloat = 5
        static let RoundedButtonAngleWidth: CGFloat = 14
        
        struct Feed {
            static let AddNewCellHeight: CGFloat = 137.0
            static let FeedOptionHeight: CGFloat = 44.0
            static let FeedBottomPadding: CGFloat = 80.0
        }
        
        struct Map {
            static let EarthRadius = 6371000.0
            static let DefaultRange = 500.0
            static let DistanceFilter = 5.0
        }
        
        struct Menu {
            static let RowHeight:CGFloat = 42.0
        }
        
        struct Header {
            static let HeroExpandHeight: CGFloat = 157.0
            static let HeroCollapseHeight: CGFloat = 59.0
            static let ButtonPadding: CGFloat = 20.0
            static let TitleY0: CGFloat = 30.0
            static let TitleY1: CGFloat = 62.0
            static let TitleHeight: CGFloat = 20.0
            static let FontSize: CGFloat = 18.0
            static let ButtonIndent: CGFloat = 8.0
        }
        
        struct Post {
            static let ImageRatio: CGFloat = 0.5
            static let PointHeight: CGFloat = 5.0
            static let PointWidth: CGFloat = 10.0
            static let ShadowOffset: CGFloat = 1.0
            static let ShadowBlur: CGFloat = 0.6
            static let DefaultViewHeight: CGFloat = 166.0
            static let DefaultCaptionHeight: CGFloat = 32.0
            static let DefaultHeaderViewHeight: CGFloat = 136.0
            static let DefaultHeaderCaptionHeight: CGFloat = 48.0
            static let DetailFooterHeight: CGFloat = 84.0
        }
        
        struct Comment {
            static let DefaultHeight: CGFloat = 124.0
            static let DefaultCommentHeight: CGFloat = 44.0
        }
        
        struct Upload {
            static let ImageQuality: CGFloat = 0.3
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
