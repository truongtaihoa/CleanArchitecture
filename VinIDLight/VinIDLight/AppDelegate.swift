//
//  AppDelegate.swift
//  VinIDLight
//
//  Created by Trung Luân on 11/12/19.
//  Copyright © 2019 VinID. All rights reserved.
//

import UIKit
import RIBs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    private var launchRouter: LaunchRouting?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let launchRouter = TaskListBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        
        window.rootViewController = UINavigationController(rootViewController: launchRouter.viewControllable.uiviewController)
        window.makeKeyAndVisible()
        
        launchRouter.interactable.activate()
        launchRouter.load()
        
        return true
    }
}

