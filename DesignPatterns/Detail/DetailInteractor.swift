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
    func getJob()
    func loadCompanyLogo(stringUrl: String?)
}

protocol DetailInteractorOutput: AnyObject {
    func changed(companyLogo: UIImage?)
    func changed(job: Job)
}

final class DetailInteractor {
    private weak var presenter: DetailInteractorOutput?
    private var job: Job?
    
    init(job: Job) {
        self.job = job
    }
}

extension DetailInteractor: DetailInteractorInput {
    func set(presenter: DetailInteractorOutput) {
        self.presenter = presenter
    }
    
    func getJob() {
//        return job
    }
    
    func loadCompanyLogo(stringUrl: String?) {
        stringUrl?.image { [unowned self] (image) in
            self.presenter?.changed(companyLogo: image)
        }
    }
}
