//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

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
    private var job: Job?
    
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
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if descriptionLabel.isTruncated {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                self.readMoreButtonConstraint.constant = Constants.ReadMoreButton.heightConstraint
                self.view.layoutIfNeeded()
                let bottomLayer = CALayer()
                bottomLayer.backgroundColor = UIColor.black.cgColor
                bottomLayer.frame = CGRect(x: 0, y: 0, width: self.readMoreButton.frame.width, height: Constants.ReadMoreButton.heightConstraint)
                self.readMoreButton.layer.addSublayer(bottomLayer)
            }
        }
    }
    
    func set(job: Job) {
        self.job = job
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    @objc func websiteUrlButtonTapped() {
        guard let url = job?.companyUrl else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func readMoreButtonTapped() {
        guard let jobDescriptionViewController = UIStoryboard.detail.instantiateViewController(withIdentifier: JobDescriptionViewController.storyboardIdentifier) as? JobDescriptionViewController, let attributedDescriptionText = job?.attributedDescriptionText else {
            return
        }
        jobDescriptionViewController.set(attributedDescription: attributedDescriptionText)
        navigationController?.pushViewController(jobDescriptionViewController, animated: true)
    }
    
    func setupData() {
        nameLabel.text = job?.companyName
        websiteUrlButton.setTitle(job?.companyUrlString, for: .normal)
        websiteUrlButton.setTitle("No URL", for: .disabled)
        locationLabel.text = job?.location ?? "No Location Data"
        
        if job?.companyUrl == nil {
            websiteUrlButton.isEnabled = false
        }
        
        if let attributedDesription = job?.attributedDescriptionText {
            descriptionLabel.attributedText = attributedDesription
        }
        
        job?.imageUrl?.loadImage { [weak self] (image) in
            self?.companyImageView.image = image
        }
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
        companyImageView.contentMode = .scaleAspectFit
        readMoreButton.setTitleColor(CurrentEnvironment.color.darkGray, for: .normal)
        readMoreButton.backgroundColor = CurrentEnvironment.color.softGray
    }
    
    func setupSelectors() {
        websiteUrlButton.addTarget(self, action: #selector(websiteUrlButtonTapped), for: .touchUpInside)
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
}
