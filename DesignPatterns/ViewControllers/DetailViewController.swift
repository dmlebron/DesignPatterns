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
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        nameLabel.text = job?.companyName
        
        websiteLabel.text = job?.companyUrlString ?? "No URL"
        locationLabel.text = job?.location ?? "No Location Data"
        
        if let attributedDesription = job?.attributedDescriptionText {
            descriptionTextView.attributedText = attributedDesription
        }
        
        job?.companyLogo?.image { [weak self] (image) in
            self?.companyImageView.image = image
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
    }
    
    func set(job: Job) {
        self.job = job
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
        companyImageView.contentMode = .scaleAspectFit
    }
}
