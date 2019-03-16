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
    }
}

// MARK: - Constants
private extension DetailViewController {
    enum Constants {
        enum ReadMoreButton {
            static var bottomLayerHeight: CGFloat { return 1 }
            static var heightConstraint: CGFloat { return 30 }
        }
    }
}

final class DetailViewController: UIViewController {
    private(set) var viewModel: DetailViewModelInput!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var websiteUrlButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMoreButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.shouldShowReadMoreButton(isDescriptionLabelTruncated: descriptionLabel.isTruncated)
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    @objc func websiteButtonTapped() {
        viewModel.websiteButtonTapped()
    }
    
    @objc func readMoreButtonTapped() {
        viewModel.readMoreButtonTapped()
    }
}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewModelOutput {
    func changed(viewData: ViewData) {
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        descriptionLabel.attributedText = viewData.description
    }
    
    func set(viewModel: DetailViewModelInput) {
        self.viewModel = viewModel
    }
    
    func set(companyLogo: UIImage?) {
        companyImageView.image = companyLogo
    }
    
    func set(websiteUrlState: WebsiteUrlState) {
        websiteUrlButton.setTitle(websiteUrlState.title, for: .normal)
        websiteUrlButton.isEnabled = websiteUrlState.isEnabled
    }
    
    func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    func showReadMoreButton() {
        self.readMoreButtonConstraint.constant = Constants.ReadMoreButton.heightConstraint
        self.view.layoutIfNeeded()
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = viewModel.color.darkGray
        topDividerView.backgroundColor = viewModel.color.darkGray
        companyImageView.contentMode = .scaleAspectFit
        readMoreButton.setTitleColor(viewModel.color.darkGray, for: .normal)
        readMoreButton.backgroundColor = viewModel.color.softGray
    }
    
    func setupSelectors() {
        websiteUrlButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
}
