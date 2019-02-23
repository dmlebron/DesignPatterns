//
//  DetailViewController.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    private var job: Job?
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoaded()
        companyNameLabel.text = job?.companyName
    }
    
    func set(job: Job) {
        self.job = job
    }
}

// MARK: - ViewCustomizing
extension DetailViewController: ViewCustomizing {
    func setupUI() {
        companyNameLabel.textColor = CurrentEnvironment.color.darkGray
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
    }
}
