//
//  MainModuleBuilder.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct MainModuleBuilder {
    var module: UIViewController {
        let view = UIStoryboard.main.instantiateInitialViewController() as! MainViewController
        let router = MainRouter()
        let interactor = MainInteractor()
        let presenter = MainPresenter(interactor: interactor, router: router)
        interactor.set(presenter: presenter)
        presenter.set(view: view)
        view.set(presenter: presenter)
        return view
    }
}
