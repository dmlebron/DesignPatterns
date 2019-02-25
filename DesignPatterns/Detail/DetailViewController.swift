//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

// MARK: - Objects
extension DetailViewController {
    struct ViewData {
        let name: String
        let description: NSAttributedString
        let location: String
        let urlString: String
    }
    
    struct WebsiteUrlState {
        let isEnabled: Bool
        let title: String
        let state: UIControl.State
    }
}

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModelInput!
    
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
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    @objc func websiteUrlButtonTapped() {
        viewModel.websiteUrlButtonTapped()
    }
}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewModelOutput {
    func changed(viewData: ViewData) {
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        descriptionTextView.attributedText = viewData.description
    }
    
    func set(viewModel: DetailViewModelInput) {
        self.viewModel = viewModel
    }
    
    func set(companyLogo: UIImage?) {
        companyImageView.image = companyLogo
    }
    
    func set(websiteUrlState: WebsiteUrlState) {
        websiteUrlButton.setTitle(websiteUrlState.title, for: websiteUrlState.state)
        websiteUrlButton.isEnabled = websiteUrlState.isEnabled
    }
    
    func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
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
