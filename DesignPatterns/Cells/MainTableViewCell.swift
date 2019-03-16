//
//  MainTableViewCell.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var color: Color! {
        didSet {
            customize()
        }
    }
}

// MARK: - ViewCustomizing
extension MainTableViewCell: ViewCustomizing {
    func setupUI() {
        titleLabel.textColor = color.darkGray
        companyNameLabel.textColor = color.darkGray
    }
}

// MARK: - CellRegistration
extension MainTableViewCell: CellRegistration {}
