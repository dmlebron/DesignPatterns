//
//  DetailPresenter.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

// MARK: - Constants
extension DetailPresenter {
    enum Constants {
        static var noUrlString: String { return "No URL" }
        static var noLocationString: String { return "No Location Data" }
        static var noDescriptionAttributedString: NSAttributedString { return NSAttributedString(string: "No Desription") }
    }
}

final class DetailPresenter {
    typealias ViewData = DetailViewController.ViewData
    let router: DetailRouterInput
    let interactor: DetailInteractorInput
    private var job: Job?
    weak var view: DetailViewInput?
    
    init(interactor: DetailInteractorInput, router: DetailRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - DetailViewOutput
extension DetailPresenter: DetailViewOutput {
    func viewDidLoad() {
        interactor.fetchJob()
    }

    func websiteUrlButtonTapped(url: URL?) {
        router.openUrl(url)
    }
    
    func readMoreButtonTapped(context: UINavigationController?, attributedDescription: NSAttributedString) {
        router.navigateToJobDescriptionViewController(context: context, attributedDescription: attributedDescription)
    }
}

// MARK: - DetailInteractorOutput
extension DetailPresenter: DetailInteractorOutput {
    func set(view: DetailViewInput) {
        self.view = view
    }

    func changed(job: Job) {
        prepareViewModel(job: job)
    }
    
    func loaded(companyLogo: UIImage?) {
        view?.set(companyLogo: companyLogo)
    }
}

// MARK: - Private Methods
private extension DetailPresenter {
    func prepareViewModel(job: Job) {
        let name = job.companyName
        let attributedDescription = job.attributedDescriptionText ?? Constants.noDescriptionAttributedString
        let location = job.location ?? Constants.noLocationString
        let urlString = job.companyUrlString ?? Constants.noUrlString
        let isWebsiteButtonEnabled = job.companyUrl != nil
        let viewData = ViewData(name: name,
                                description: attributedDescription,
                                location: location,
                                urlString: urlString,
                                url: job.companyUrl,
                                isWebsiteButtonEnabled: isWebsiteButtonEnabled)
        view?.changed(viewData: viewData)
    }
}
