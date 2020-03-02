//
//  AppDelegate.swift
//  SmartSafety
//
//  Created by Abdullah Ayyad on 06/09/2019.
//  Copyright © 2019 Abdullah Ayyad. All rights reserved.
//

import UIKit
import MOLH
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    
    var appContent :AppContent?
    var sortedBy = SortedDialogVC._default
    
    var openFromNotifications = (fromNotificaiton :false,NotificationTypes: NotificationTypes.other,modelName: "other",modelId :"0")
    //SmartSafty
    static let GOOGLE_MAP_API_KEY = "AIzaSyA_wumWncuQeIQMfQ1GNx6BB5v1CNFm3vI"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        registerNotification()
        Messaging.messaging().delegate = self

        GMSServices.provideAPIKey(AppDelegate.GOOGLE_MAP_API_KEY)
   
        
        initLanguage()
        
        initApperance()
        
        if let lo = launchOptions, let userInfo = lo[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
                handelNotification(ofUserInfo: userInfo)
            }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func initApperance(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:   "SSTArabic-Medium" , size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:   "SSTArabic-Medium", size: 10)!], for: .selected)
        
        
        
        UITabBarItem.appearance().setBadgeTextAttributes([NSAttributedString.Key.font: UIFont(name: "BahijTheSansArabic-Light", size: 10) as Any], for: .normal)
        UITabBarItem.appearance().setBadgeTextAttributes([NSAttributedString.Key.font: UIFont(name: "BahijTheSansArabic-Light", size: 10) as Any], for: .selected)
        
        
        
        UIFont.overrideInitialize()

        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    
    func registerNotification(){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerForRemoteNotifications()

        }

        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (grant, error) in
//            if grant {
//                DispatchQueue.main.sync {
//                    UIApplication.shared.registerForRemoteNotifications()
//                    UNUserNotificationCenter.current().delegate = self
//
//                }
//            }
//        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        Messaging.messaging().apnsToken = deviceToken as Data

        print("device APNs token : \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error :\(error)")
    }
    

      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
         print("userInfo\(userInfo)")
           if application.applicationState == .active {


              let aps = userInfo["aps"] as! [String:Any]

              let alert  = aps["alert"] as! [String:Any]

              let text = alert["title"] as! String


              NotificationCenter.default.post(name: NSNotification.Name("messageFormNotification"), object: nil, userInfo: ["title":text])
           }else{
            handelNotification(ofUserInfo: userInfo)
            }

        completionHandler(UIBackgroundFetchResult.newData)

      }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject], annotation:Any, sourceApplication:String?) -> Bool {
        return true
        
    }
    
    
    
    func handelNotification(ofUserInfo userInfo :[AnyHashable : Any]){
        if userInfo["model_name"] != nil {

            let modelName = userInfo["model_name"] as? String  ?? "other"
            let modelId = userInfo["model_id"] as? String ?? "0"

            let id = userInfo["id"] as? String ?? "0"
            let isSeen = userInfo["is_seen"] as? String ?? "1"


            if MatajerUtility.isLogin() {
                if isSeen == "0" {
                API.SET_NOTIFICATION.startRequest(nestedParams:"\(id)"){ _,_ in
                    }
                }
            }

            let type = NotificationTypes(rawValue: modelName) ?? .other

            openFromNotifications.fromNotificaiton = true
            openFromNotifications.NotificationTypes = type
            openFromNotifications.modelName = modelName
            openFromNotifications.modelId = modelId


            NotificationCenter.default.post(name: MainTabBarVC.messageFormNotification, object: nil, userInfo: [:])

            Messaging.messaging().appDidReceiveMessage(userInfo)

         }
        
    }
}


extension AppDelegate : MOLHResetable{
    static var shared : AppDelegate{
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate
        }
    }
    
    
    func initLanguage(){
        MOLHLanguage.setDefaultLanguage("ar")
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage())
        //MOLHFont.shared.english = UIFont(name: "JFFlat-Regular", size: 50)!
        //MOLHFont.shared.arabic = UIFont(name: "JFFlat-Regular", size: 50)!
         MOLH.shared.activate(true)
    }
    
    
    
    
    var viewController :UIViewController {
        get{
            var topController = self.window!.rootViewController!
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
    }
    
    
    
    var language :String {
        set{
            MOLH.setLanguageTo(newValue)
            MOLH.reset()
        }
        get{
            return MOLHLanguage.currentAppleLanguage()
        }
    }
    
    var local :Locale {
        get{
            return Locale(identifier: MOLHLanguage.currentLocaleIdentifier())
        }
    }
    
    func reset() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LunchScreenVC")
        self.window!.rootViewController = vc
    }
    
}
//
extension AppDelegate :MessagingDelegate ,UNUserNotificationCenterDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    //f6viKd5XqyM:APA91bHiFrAAF4pncyf6v3Lle5-gL06uBIPV7Fmj03IpVZszUwjAEh6cFpesS3ATbuwwXndICdrkRFiqoxQICeU5jGFx4Ovx6EqUSYDaLqhfN1ey72-KOlXOAxV4H1ayvf1bUPQ85GW_
        print("FCM Token: \(fcmToken)")


    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {


        handelNotification(ofUserInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
}



 

