//
//  AppDelegate.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GDPerformanceView
import Chameleon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        GDPerformanceMonitor.sharedInstance.startMonitoring()

        BuddyBuildSDK.setup()

        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor(hexString: "#ECEFF1"), with: .contrast)

        return true
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if Optimizely.handleOpen(url) {
//            return true
//        }
//        return false
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        GDPerformanceMonitor.sharedInstance.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        GDPerformanceMonitor.sharedInstance.stopMonitoring()
    }

}
