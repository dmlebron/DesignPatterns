//
//  AppDelegate.swift
//
//  Created by david martinez on 2/22/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

let CurrentEnvironment = Environment.development
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CurrentEnvironment.locationService.requestWhenInUseAuthorization()
        return true
    }
}

