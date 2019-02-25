//
//  ModuleBuilder.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct ModuleBuilder {
    func main() -> UIViewController {
        let mainViewController = UIStoryboard.main.instantiateInitialViewController() as! MainViewController
        let mainViewModel = MainViewModel(output: mainViewController)
        mainViewController.set(viewModel: mainViewModel)
        return mainViewController
    }
    
    func detail(job: Job) -> UIViewController {
        let detailViewController = UIStoryboard.detail.instantiateInitialViewController() as! DetailViewController
        let detailViewModel = DetailViewModel(output: detailViewController, job: job)
        detailViewController.set(viewModel: detailViewModel)
        return detailViewController
    }
}
