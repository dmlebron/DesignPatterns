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
        let location: String
        let urlString: String
        let url: URL?
        let isWebsiteButtonEnabled: Bool
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
    }
}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewInput {
    func changed(viewData: ViewData) {
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        descriptionTextView.attributedText = viewData.description
        prepareWebsiteUrlButton(viewData: viewData)
        self.viewData = viewData
    }
    
    func set(presenter: DetailViewOutput) {
        self.presenter = presenter
    }
    
    func set(companyLogo: UIImage?) {
        companyImageView.image = companyLogo
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    @objc func websiteUrlButtonTapped() {
        presenter.websiteUrlButtonTapped(url: viewData?.url)
    }

    func prepareWebsiteUrlButton(viewData: ViewData) {
        websiteUrlButton.setTitle(viewData.urlString, for: .normal)
        websiteUrlButton.isEnabled = viewData.isWebsiteButtonEnabled
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
