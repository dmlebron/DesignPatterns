//
//  MainTableViewCell.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    struct ViewData {
        let titleLabelColor: UIColor
        let companyLabelColor: UIColor
        let title: String
        let companyName: String?
    }
    
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
}

extension MainTableViewCell {
    func setup(viewData: ViewData) {
        titleLabel.textColor = viewData.titleLabelColor
        companyNameLabel.textColor = viewData.companyLabelColor
        titleLabel.text = viewData.title
        companyNameLabel.text = viewData.companyName
    }
}

// MARK: - CellRegistration
extension MainTableViewCell: CellRegistration {}
