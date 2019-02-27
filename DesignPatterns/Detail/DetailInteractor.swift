//
//  DetailInteractor.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol DetailInteractorInput: AnyObject {
    func set(presenter: DetailInteractorOutput)
    func fetchJob()
}

protocol DetailInteractorOutput: AnyObject {
    func changed(job: Job)
}

final class DetailInteractor {
    private weak var presenter: DetailInteractorOutput?
    private let job: Job
    
    init(job: Job) {
        self.job = job
    }
}

// MARK: - DetailInteractorInput
extension DetailInteractor: DetailInteractorInput {
    func set(presenter: DetailInteractorOutput) {
        self.presenter = presenter
    }
    
    func fetchJob() {
        presenter?.changed(job: job)
    }
}
