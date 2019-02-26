//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol DetailViewInput: AnyObject {
    func changed(viewData: DetailViewController.ViewData)
    func set(companyLogo: UIImage?)
}

protocol DetailViewOutput: AnyObject {
    func set(view: DetailViewInput)
    func viewDidLoad()
    func websiteUrlButtonTapped(url: URL?)
}

// MARK: - Objects
extension DetailViewController {
    struct ViewData {
        let name: String
        let description: NSAttributedString
        let location: String?
        let urlString: String?
        let url: URL?
    }
    
    enum Constants {
        static var noUrlString: String { return "No URL" }
        static var noLocationString: String { return "No Location Data" }
        static var noDescriptionAttributedString: NSAttributedString { return NSAttributedString(string: "No Desription") }
    }
}

final class DetailViewController: UIViewController {
    private var presenter: DetailViewOutput!
    private var viewData: ViewData?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var websiteUrlButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        presenter.viewDidLoad()
        prepareWebsiteUrl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    @objc func websiteUrlButtonTapped() {
        presenter.websiteUrlButtonTapped(url: viewData?.url)
    }
    
    func prepareWebsiteUrl() {
        if let urlString = viewData?.urlString {
            websiteUrlButton.setTitle(urlString, for: .normal)
            websiteUrlButton.isEnabled = true
        } else {
            websiteUrlButton.setTitle(Constants.noUrlString, for: .disabled)
            websiteUrlButton.isEnabled = false
        }
    }

}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewInput {
    func changed(viewData: ViewData) {
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        descriptionTextView.attributedText = viewData.description
    }
    
    func set(presenter: DetailViewOutput) {
        self.presenter = presenter
    }
    
    func set(companyLogo: UIImage?) {
        companyImageView.image = companyLogo
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
        companyImageView.contentMode = .scaleAspectFit
    }
    
    func setupSelectors() {
        websiteUrlButton.addTarget(self, action: #selector(websiteUrlButtonTapped), for: .touchUpInside)
    }
}
