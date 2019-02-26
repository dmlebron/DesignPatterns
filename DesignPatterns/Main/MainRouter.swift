//
//  MainRouter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol MainRouterInput: AnyObject {
    static func navigationControllerForMainModuleSetup(builder: MainModuleBuilder) -> UINavigationController
    func navigateToDetailViewController(context: UINavigationController, job: Job)
}

final class MainRouter: MainRouterInput {
    static func navigationControllerForMainModuleSetup(builder: MainModuleBuilder) -> UINavigationController {
        let module = builder.module
        let context = UINavigationController(rootViewController: module)
        return context
    }
    
    func navigateToDetailViewController(context: UINavigationController, job: Job) {
        let builder = DetailModuleBuilder()
        DetailRouter.present(job: job, builder: builder, context: context)
    }
}
