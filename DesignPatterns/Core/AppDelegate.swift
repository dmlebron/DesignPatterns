//
//  AppDelegate.swift
//
//  Created by david martinez on 2/22/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

var CurrentEnvironment = Environment.development

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CurrentEnvironment.locationService.requestWhenInUseAuthorization()
        setupSharedUI()
        return true
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func setupSharedUI() {
        UINavigationBar.appearance().barTintColor = CurrentEnvironment.color.darkGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: CurrentEnvironment.color.light]
    }
}
