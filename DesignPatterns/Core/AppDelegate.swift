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
        let color = Color()
        
        setupSharedUI(color: color)
        
        let locationService = LocationService()
        locationService.requestWhenInUseAuthorization()
        
        let apiClient = ApiClient()
        let imageCache = ImageCache()
        let imageLoading = ImageLoader(imageCache: imageCache)
        
        setupWindow(locationService: locationService, apiClient: apiClient, imageLoading: imageLoading)
        
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
    
    func setupWindow(locationService: LocationServiceType, apiClient: ApiClientType, imageLoading: ImageLoading) {
        let mainBuilder = MainModuleBuilder(locationService: locationService, apiClient: apiClient, imageLoading: imageLoading)
        let navigationController = MainRouter.navigationControllerForMainModuleSetup(builder: mainBuilder)
        let window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
