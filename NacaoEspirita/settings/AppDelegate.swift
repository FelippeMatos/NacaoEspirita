//
//  AppDelegate.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/14/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
   
        UISearchBar.appearance().tintColor = AppColor.MAIN_BLUE
        UINavigationBar.appearance().tintColor = AppColor.MAIN_BLUE
        
        checkUserState()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func checkUserState() {
        let select: UIViewController
        
        if Auth.auth().currentUser != nil {
            select = HomeRouter.createModuleTabBar()
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = select
            window?.makeKeyAndVisible()
        } else {
            select = LoginRouter.createModule()
            setInitialScreen(select: select)
        }
        
       
    }
    func setInitialScreen(select: UIViewController) {
        
        /* Initiating instance of ui-navigation-controller with view-controller */
        let navigationController = UINavigationController()
        navigationController.viewControllers = [select]
        
        /* Setting up the root view-controller as ui-navigation-controller */
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}

