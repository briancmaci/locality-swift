//
//  PushNotificationManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/5/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Mapbox

class PushNotificationManager: NSObject {
    
    static let shared = PushNotificationManager()
    
    class func registerForRemoteNotifications() {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = UIApplication.shared.delegate as? FIRMessagingDelegate
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(shared,
                                               selector: #selector(tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM with token: \(String(describing: FIRInstanceID.instanceID().token()))")
                
                
                //TODO: We will need logic here for not doing this a billion times
                //Save token
                //DispatchQueue.once(block: { () in
                
                if FIRAuth.auth()?.currentUser != nil {
                    FirebaseManager.write(token: FIRInstanceID.instanceID().token()!, completionHandler: { (error) in
                        if error != nil {
                            print("Token push error: \(String(describing: error?.localizedDescription))")
                        } else {
                            CurrentUser.shared.notificationToken = FIRInstanceID.instanceID().token()!
                            print("TOKEN SAVED!")
                        }
                    })
                }
                //})
                
                
                //connect to all-devices once
                DispatchQueue.once(block: { () in
                    
                    //TODO: MOVE THESE TO ONCE WE HAVE FIRST LOGGED IN!!!!
                    print("Subscribed to topic \(K.Push.TopicBase + K.Push.Topic.AllDevices)")
                    FIRMessaging.messaging().subscribe(toTopic: K.Push.TopicBase + String(format: K.Push.Topic.UserIdFormat, CurrentUser.shared.uid))
                })
            }
        }
    }
    
    func disconnectFcm() {
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM")
    }
    
    class func loadPostFromNotification(_ thisData: [AnyHashable: Any]) {
        
        let lat = (thisData["lat"] as! NSString).doubleValue
        let lon = (thisData["lon"] as! NSString).doubleValue
        let caption = thisData["caption"] as! String
        let dateInt = (thisData["date"] as! NSString).intValue
        let createdDate = Util.dateFromInt(dateInt: Int(dateInt))
        let postId = thisData["postId"] as! String
        let commentCount = (thisData["commentCount"] as! NSString).intValue
        let uid = thisData["uid"] as! String
        let imgUrl = thisData["postImageUrl"] as! String
        let isAnonymous = (thisData["isAnon"] as! String).toBool()
        
        FirebaseManager.getUserFromHandle(uid: uid) { (thisUser) in
            
            if thisUser == nil {
                print("User no longer exists")
                return
            }
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let thisPost = UserPost(coord: coord, caption: caption, imgUrl: imgUrl, user: thisUser!)
            
            thisPost.commentCount = Int(commentCount)
            thisPost.postId = postId
            thisPost.createdDate = createdDate
            thisPost.postImageUrl = imgUrl
            thisPost.isAnonymous = isAnonymous!
            
            let vc = PostDetailViewController(nibName: K.NIBName.VC.PostDetail, bundle: nil)
            vc.thisPost = thisPost
            SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
            
        }
    }

}
