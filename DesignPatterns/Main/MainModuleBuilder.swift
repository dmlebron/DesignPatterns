//
//  MainModuleBuilder.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct MainModuleBuilder {
    private let locationService: LocationServiceType
    private let apiClient: ApiClientType
    private let imageLoading: ImageLoading
    
    init(locationService: LocationServiceType, apiClient: ApiClientType, imageLoading: ImageLoading) {
        self.locationService = locationService
        self.apiClient = apiClient
        self.imageLoading = imageLoading
    }
    
    var module: UIViewController {
        let view = UIStoryboard.main.instantiateInitialViewController() as! MainViewController
        let router = MainRouter()
        let interactor = MainInteractor(locationService: locationService, apiClient: apiClient)
        let presenter = MainPresenter(interactor: interactor, router: router, imageLoading: imageLoading)
        
        interactor.set(presenter: presenter)
        presenter.set(view: view)
        view.set(presenter: presenter)
        return view
    }
}
