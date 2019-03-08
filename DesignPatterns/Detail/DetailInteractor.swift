//
//  DetailInteractor.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

//MARK: - To be Conformed by DetailInteractor
protocol DetailInteractorInput: AnyObject {
    func set(presenter: DetailInteractorOutput)
    func fetchJob()
}

//MARK: - To be Conformed by DetailPresenter
protocol DetailInteractorOutput: AnyObject {
    func changed(job: Job)
    func loaded(companyLogo: UIImage?)
}

final class DetailInteractor {
    private weak var presenter: DetailInteractorOutput?
    private let job: Job
    let userLocation: Location?
    
    init(job: Job, userLocation: Location?) {
        self.job = job
        self.userLocation = userLocation
    }
}

// MARK: - DetailInteractorInput
extension DetailInteractor: DetailInteractorInput {
    func set(presenter: DetailInteractorOutput) {
        self.presenter = presenter
    }
    
    func fetchJob() {
        presenter?.changed(job: job)
        CurrentEnvironment.imageLoader.load(url: job.imageUrl) { [weak self] (image) in
            self?.presenter?.loaded(companyLogo: image)
        }
    }
}
