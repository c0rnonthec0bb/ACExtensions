//
//  Delegate.swift
//  Revree UI Test
//
//  Created by Adam Cobb on 4/23/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

@UIApplicationMain
open class AppDelegateX: UIResponder, UIApplicationDelegate {
    
    open var window: UIWindow?
    
    open func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIViewControllerX.context.onWindowFocusChanged(false)
        UIViewControllerX.context.onPause()
        UIViewControllerX.context.onStop()
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIViewControllerX.context.onStart()
        UIViewControllerX.context.onResume()
        UIViewControllerX.context.onWindowFocusChanged(true)
    }
}
