//
//  DetailPresenter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

final class DetailPresenter {
    private let router: DetailRouterInput
    private let interactor: DetailInteractorInput
    weak var view: DetailViewInput?
    
    init(interactor: DetailInteractorInput, router: DetailRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - DetailViewOutput
extension DetailPresenter: DetailViewOutput {
    func viewDidLoad() {
        guard let name = job?.companyName,
        let attributedDescription = job?.attributedDescriptionText else { return }
        let viewData = DetailViewController.ViewData(name: name, description: attributedDescription, location: job?.location, urlString: job?.companyUrlString, url: job?.companyUrl)
        view?.changed(viewData: viewData)
    }
    
    func loadCompanyLogo(urlString: String?) {
        interactor.loadCompanyLogo(stringUrl: urlString)
    }
    
    func websiteUrlButtonTapped(url: URL?) {
        router.openUrl(url)
    }
}

// MARK: - DetailInteractorOutput
extension DetailPresenter: DetailInteractorOutput {
    func set(view: DetailViewInput) {
        self.view = view
    }
    
    func changed(companyLogo: UIImage?) {
        view?.set(companyLogo: companyLogo)
    }
}
