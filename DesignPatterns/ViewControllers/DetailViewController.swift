//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

// MARK: - DataDisplayable
extension DetailViewController: DataDisplayable {
    struct ViewData {
        let name: String
        let companyUrl: String?
        let attributedDescription: NSAttributedString?
        let location: String?
        let imageUrlString: String?
    }
}

class DetailViewController: UIViewController {
    private var viewData: ViewData?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoaded()
        nameLabel.text = viewData?.name
        
        websiteLabel.text = viewData?.companyUrl ?? "No URL"
        locationLabel.text = viewData?.location ?? "No Location Data"
        
        if let attributedDesription = viewData?.attributedDescription {
            descriptionTextView.attributedText = attributedDesription
        }
        
        viewData?.imageUrlString?.image { [weak self] (image) in
            self?.companyImageView.image = image
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.contentOffset = .zero
    }
    
    func set(viewData: ViewData) {
        self.viewData = viewData
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
        imageView.contentMode = .scaleAspectFit
    }
}
