//
//  ModuleBuilder.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct ModuleBuilder {
    func main() -> UINavigationController {
        let navigationController = UIStoryboard.main.instantiateInitialViewController() as! UINavigationController
        let mainViewController = navigationController.topViewController as! MainViewController
        let mainViewModel = MainViewModel(output: mainViewController)
        mainViewController.setViewModel(mainViewModel)
        return navigationController
    }
}
