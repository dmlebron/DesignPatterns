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
    }
}

class DetailViewController: UIViewController {
    private var viewData: ViewData?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationAndUrlStackView: UIStackView!
    @IBOutlet weak var locationAndUrlHeightConstaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoaded()
        nameLabel.text = viewData?.name
        
        websiteLabel.text = viewData?.companyUrl ?? "No URL"
        locationLabel.text = viewData?.location ?? "No Location Data"
        
        if let attributedDesription = viewData?.attributedDescription {
            descriptionTextView.attributedText = attributedDesription
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

// MARK: - Private Methods
private extension DetailViewController {
    func updateLocationAndUrlStackViewConstraint() {
        guard viewData?.companyUrl == nil && viewData?.location == nil else {
            locationAndUrlHeightConstaint.isActive = false
            return
        }
        locationAndUrlHeightConstaint.constant = 0
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        nameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
    }
}
