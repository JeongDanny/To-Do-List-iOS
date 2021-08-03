//
//  AppDelegate.swift
//  TodoList
//
//  Created by paytalab on 2021/08/02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainViewController.newInstance()
        self.window = window
        window.makeKeyAndVisible()
        
        gDB.sync()
        
        return true
    }
}
