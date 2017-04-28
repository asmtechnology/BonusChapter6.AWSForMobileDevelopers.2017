//
//  AppDelegate.swift
//  AWSChat
//
//  Created by Abhishek Mishra on 07/03/2017.
//  Copyright © 2017 ASM Technology Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = "332977463957-7gm2ujbe6q2cif7iof6fbgqvpanrbgkb.apps.googleusercontent.com"
        
        // request permission for push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if granted {
                application.registerForRemoteNotifications()
            } else {
                print("Permission denied: \(error?.localizedDescription)")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenBytes = [UInt8](deviceToken)
        var deviceTokenString = ""
        
        for byte in deviceTokenBytes {
            deviceTokenString += String(format: "%02x",byte)
        }
        
        let snsController = SNSController.sharedInstance
        snsController.apnsDeviceToken = deviceTokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notifications:", error)
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let state = UIApplication.shared.applicationState
        if state != .active {
            return
        }
        
        guard let pushDictionary = userInfo["aps"] as? [AnyHashable : Any],
            let message = pushDictionary["alert"] as? String else {
                return
        }
        
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil)
        alertController.addAction(action)
        
        DispatchQueue.main.async {
            let viewController = self.topMostViewController()
            viewController.present(alertController, animated: true, completion:  nil)
        }
        
    }
    
    func topMostViewController() -> UIViewController {
        
        var viewController = UIApplication.shared.keyWindow!.rootViewController!
        while viewController.presentedViewController != nil {
            viewController = viewController.presentedViewController!
        }
        
        return viewController
    }

    
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        
        if url.scheme?.compare("fb1080694568742908") == .orderedSame {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url as URL!,
                sourceApplication: sourceApplication,
                annotation: annotation)
            
        } else {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: sourceApplication,
                                                     annotation: annotation)
        }
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

