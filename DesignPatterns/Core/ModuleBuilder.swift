//
//  ModuleBuilder.swift
//
//  Created by david martinez on 2/24/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct ModuleBuilder {
    func main(locationService: LocationServiceType, apiClient: ApiClientType, color: Color, imageLoader: ImageLoading) -> UIViewController {
        let mainViewController = UIStoryboard.main.instantiateInitialViewController() as! MainViewController
        let mainViewModel = MainViewModel(locationService: locationService, apiClient: apiClient, color: color, imageLoader: imageLoader)
        mainViewController.set(viewModel: mainViewModel)
        return mainViewController
    }
    
    func detail(job: Job, imageLoader: ImageLoading, color: Color) -> UIViewController {
        let detailViewController = UIStoryboard.detail.instantiateInitialViewController() as! DetailViewController
        let detailViewModel = DetailViewModel(output: detailViewController, job: job, imageLoader: imageLoader, color: color)
        detailViewController.set(viewModel: detailViewModel)
        return detailViewController
    }
}
