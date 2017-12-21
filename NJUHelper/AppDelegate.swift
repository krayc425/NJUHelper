//
//  AppDelegate.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/20.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SVProgressHUD.setDefaultStyle(.dark)
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "login" {
            if let username = UserDefaults.standard.value(forKey: "pnju_username") as? String,
                let password = UserDefaults.standard.value(forKey: "pnju_password") as? String {
                PNJUHelper.shared.login(username: username, password: password, completion: { msg in
                    SVProgressHUD.showInfo(withStatus: msg)
                    SVProgressHUD.dismiss(withDelay: 1.0)
                })
            } else {
                SVProgressHUD.showInfo(withStatus: "请至少成功登录一次，以保存您的用户名和密码")
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        } else if shortcutItem.type == "logout" {
            PNJUHelper.shared.logout(completion: { msg in
                SVProgressHUD.showInfo(withStatus: msg)
                SVProgressHUD.dismiss(withDelay: 1.0)
            })
        }
    }

}

