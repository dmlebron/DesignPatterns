//
//  MainRouter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

//MARK: - To be Conformed by MainRouter
protocol MainRouterInput: AnyObject {
    static func navigationControllerForMainModuleSetup(builder: MainModuleBuilder) -> UINavigationController
    func navigateToDetailViewController(imageLoading: ImageLoading, job: Job, userLocation: Location?, context: UINavigationController)
}

final class MainRouter: MainRouterInput {
    static func navigationControllerForMainModuleSetup(builder: MainModuleBuilder) -> UINavigationController {
        let module = builder.module
        let context = UINavigationController(rootViewController: module)
        return context
    }
    
    func navigateToDetailViewController(imageLoading: ImageLoading, job: Job, userLocation: Location?, context: UINavigationController) {
        let builder = DetailModuleBuilder(imageLoader: imageLoading, job: job, userLocation: userLocation)
        DetailRouter.present(job: job, userLocation: userLocation, builder: builder, context: context)
    }
}
