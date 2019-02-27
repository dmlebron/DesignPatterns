//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    private var job: Job?
    
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
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
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
    
    func setupData() {
        nameLabel.text = job?.companyName
        websiteUrlButton.setTitle(job?.companyUrlString, for: .normal)
        websiteUrlButton.setTitle("No URL", for: .disabled)
        locationLabel.text = job?.location ?? "No Location Data"
        
        if job?.companyUrl == nil {
            websiteUrlButton.isEnabled = false
        }
        
        if let attributedDesription = job?.attributedDescriptionText {
            descriptionTextView.attributedText = attributedDesription
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
    }
    
    func setupSelectors() {
        websiteUrlButton.addTarget(self, action: #selector(websiteUrlButtonTapped), for: .touchUpInside)
    }
}
