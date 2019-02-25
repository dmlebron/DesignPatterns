//
//  AppDelegate.swift
//
//  Created by david martinez on 2/22/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

/// Environment
var CurrentEnvironment = Environment.development

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CurrentEnvironment.locationService.requestWhenInUseAuthorization()
        setupSharedUI()
        
        setupWindow()
        
        return true
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func setupSharedUI() {
        UINavigationBar.appearance().barTintColor = CurrentEnvironment.color.darkGray
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: CurrentEnvironment.color.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = CurrentEnvironment.color.white
    }
    
    func setupWindow() {
        let builder = ModuleBuilder()
        let mainViewController = builder.main()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
