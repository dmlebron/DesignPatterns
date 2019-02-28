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
    func readMoreButtonTapped(context: UINavigationController?, attributedDescription: NSAttributedString)
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
    private var presenter: DetailViewOutput!
    private var viewData: ViewData?
    
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
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if descriptionLabel.isTruncated {
            showReadMoreButton()
        }
    }
}

// MARK: - DetailViewModelOutput
extension DetailViewController: DetailViewInput {
    func changed(viewData: ViewData) {
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        descriptionLabel.attributedText = viewData.description
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
    
    @objc func readMoreButtonTapped() {
        guard let attributedDescription = viewData?.description else { return }
        presenter.readMoreButtonTapped(context: navigationController, attributedDescription: attributedDescription)
    }

    func prepareWebsiteUrlButton(viewData: ViewData) {
        websiteUrlButton.setTitle(viewData.urlString, for: .normal)
        websiteUrlButton.isEnabled = viewData.isWebsiteButtonEnabled
    }
    
    func showReadMoreButton() {
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.readMoreButtonConstraint.constant = Constants.ReadMoreButton.heightConstraint
            self.view.layoutIfNeeded()
            let bottomLayer = CALayer()
            bottomLayer.backgroundColor = UIColor.black.cgColor
            bottomLayer.frame = CGRect(x: 0, y: 0, width: self.readMoreButton.frame.width, height: Constants.ReadMoreButton.bottomLayerHeight)
            self.readMoreButton.layer.addSublayer(bottomLayer)
        }
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
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
}
