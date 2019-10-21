//
//  DetailModuleBuilder.swift
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct DetailModuleBuilder {
    private let imageLoader: ImageLoading
    private let job: Job
    private let userLocation: Location?
    
    init(imageLoader: ImageLoading, job: Job, userLocation: Location?) {
        self.imageLoader = imageLoader
        self.job = job
        self.userLocation = userLocation
    }
    
    var module: UIViewController {
        let view = UIStoryboard.detail.instantiateInitialViewController() as! DetailViewController
        let router = DetailRouter()
        let interactor = DetailInteractor(imageLoader: imageLoader, job: job, userLocation: userLocation)
        let presenter = DetailPresenter(interactor: interactor, router: router)
        
        interactor.set(presenter: presenter)
        presenter.set(view: view)
        view.set(presenter: presenter)
        
        return view
    }
}
