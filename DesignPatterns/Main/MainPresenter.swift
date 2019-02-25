//
//  MainPresenter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

final class MainPresenter {
    private let interactor: MainInteractorInput
    private let router: MainRouterInput
    private weak var view: MainViewInput?
    
    init(interactor: MainInteractorInput, router: MainRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {
    func set(view: MainViewInput) {
        self.view = view
    }
}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {
    func userLocationChanged(_ userLocation: UserLocation?) {
        
    }
    
    func changed(jobs: Jobs) {
        
    }
    
    func failed(error: Error) {
        
    }
}
