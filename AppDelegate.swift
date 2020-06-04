//
//  AppDelegate.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 17)!], for: .normal)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController(rootViewController: FirstScreenViewController())
        window!.makeKeyAndVisible()
        
        return true
    }
}
