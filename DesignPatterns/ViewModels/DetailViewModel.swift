//
//  DetailViewModel.swift
//  DesignPatterns
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol DetailViewModelInput: AnyObject {
    func viewDidLoad()
    func func websiteUrlButtonTapped()
}

protocol DetailViewModelOutput: AnyObject {
    func set(viewModel: DetailViewModelInput)
    func changed(viewData: DetailViewController.ViewData)
    func set(companyLogo: UIImage?)
}

extension DetailViewModel {
    enum Constants {
        static var noUrlString: String { return "No URL" }
        static var noLocationString: String { return "No Location Data" }
        static var noDescriptionAttributedString: NSAttributedString { return NSAttributedString(string: "No Desription") }
    }
}

final class DetailViewModel {
    private let job: Job
    weak var output: DetailViewModelOutput?
    
    init(output: DetailViewModelOutput, job: Job) {
        self.output = output
        self.job = job
    }
}

// MARK: - Private Methods
private extension DetailViewModel {
    func prepareViewData() {
        guard let name = job.companyName else { return }
        let location = job.location ?? Constants.noLocationString
        let urlString = job.companyUrlString ?? Constants.noUrlString
        let description = Constants.noDescriptionAttributedString
        let viewData = DetailViewController.ViewData(name: name, description: description, location: location, urlString: urlString)
        output?.changed(viewData: viewData)
    }
    
    func loadCompanyLogo() {
        job.companyLogo?.image { [unowned self] (image) in
            self.output?.set(companyLogo: image)
        }
    }
}

// MARK: - DetailViewModelInput
extension DetailViewModel: DetailViewModelInput {
    func viewDidLoad() {
        prepareViewData()
        loadCompanyLogo()
    }
}
