//
//  AppDelegate.swift
//
//  Created by david martinez on 2/22/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let apiClient = ApiClient()
        let color = Color()
        let locationService = LocationService()
        let imageCache = ImageCache()
        let imageLoader = ImageLoader(imageCache: imageCache)
        locationService.requestWhenInUseAuthorization()
        setupSharedUI(color: color)
        
        setupWindow(locationService: locationService, apiClient: apiClient, color: color, imageLoader: imageLoader)
        
        return true
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func setupSharedUI(color: Color) {
        UINavigationBar.appearance().barTintColor = color.darkGray
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = color.white
    }
    
    func setupWindow(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) {
        let builder = ModuleBuilder()
        let mainViewController = builder.main(locationService: locationService, apiClient: apiClient, color: color, imageLoader: imageLoader)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
