//
//  DetailRouter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

//MARK: - To be Conformed by DetailRouter
protocol DetailRouterInput: AnyObject {
    static func present(job: Job, userLocation: Location?, builder: DetailModuleBuilder, context: UINavigationController)
    func openUrl(_ url: URL?)
    func navigateToJobDescriptionViewController(context: UINavigationController?, attributedDescription: NSAttributedString)
}

final class DetailRouter {}

// MARK: - DetailRouterInput
extension DetailRouter: DetailRouterInput {
    static func present(job: Job, userLocation: Location?, builder: DetailModuleBuilder, context: UINavigationController) {
        let module = builder.module(job: job, userLocation: userLocation)
        context.pushViewController(module, animated: true)
    }

    func openUrl(_ url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
    
    func navigateToJobDescriptionViewController(context: UINavigationController?, attributedDescription: NSAttributedString) {
        let viewController = JobDescriptionModuleBuilder().module(attributedDescription: attributedDescription)
        context?.pushViewController(viewController, animated: true)
    }
}
