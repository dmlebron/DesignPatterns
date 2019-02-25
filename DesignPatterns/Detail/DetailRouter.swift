//
//  DetailRouter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol DetailRouterInput: AnyObject {
    static func present(builder: DetailModuleBuilder, context: UINavigationController)
    func navigateToDetailViewController(context: UINavigationController, job: Job)
}

final class DetailRouter: DetailRouterInput {
    static func present(builder: DetailModuleBuilder, context: UINavigationController) {
        let module = builder.module
        context.pushViewController(module, animated: true)
    }
    
    func navigateToDetailViewController(context: UINavigationController, job: Job) {
        
    }
}
