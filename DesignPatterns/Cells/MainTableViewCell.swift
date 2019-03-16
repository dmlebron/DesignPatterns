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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customize()
    }
}

// MARK: - ViewCustomizing
extension MainTableViewCell: ViewCustomizing {
    func setupUI() {
        titleLabel.textColor = CurrentEnvironment.color.darkGray
        companyNameLabel.textColor = CurrentEnvironment.color.darkGray
    }
}

// MARK: - CellRegistration
extension MainTableViewCell: CellRegistration {}
