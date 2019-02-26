//
//  DetailRouter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol DetailRouterInput: AnyObject {
    static func present(job: Job, builder: DetailModuleBuilder, context: UINavigationController)
    func openUrl(_ url: URL?)
}

final class DetailRouter: DetailRouterInput {
    static func present(job: Job, builder: DetailModuleBuilder, context: UINavigationController) {
        let module = builder.module(job: job)
        context.pushViewController(module, animated: true)
    }
    
    func openUrl(_ url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
}
