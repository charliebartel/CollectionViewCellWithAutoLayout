//
//  AppDelegate.swift
//  CollectionViewCellWithAutoLayout
//
//  Created by Charlie Bartel on 2/6/15.
//  Copyright (c) 2015 CharlieBartel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewController = AddNewViewController()
        if let window = window {
            window.rootViewController = UINavigationController(rootViewController: viewController)
            window.makeKeyAndVisible()
        }
        return true
    }
}

