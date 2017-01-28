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
import Optimizely


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self, Optimizely.self])
        Optimizely.start(withAPIToken: "AANaxDUBB0Oota8Srm-iOonZLF0m860H~8196291874", launchOptions:launchOptions)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Optimizely.handleOpen(url) {
            return true
        }
        return false
    }

}

