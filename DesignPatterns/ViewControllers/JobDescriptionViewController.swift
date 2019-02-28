//
//  JobDescriptionViewController.swift
//
//  Created by david martinez on 2/27/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

// MARK: - Constants
extension JobDescriptionViewController {
    static var storyboardIdentifier: String {
        return String(describing: JobDescriptionViewController.self)
    }
}

final class JobDescriptionViewController: UIViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    private var attributedDescription: NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let attributedDescription = attributedDescription else { return }
        descriptionTextView.attributedText = attributedDescription
    }

    func set(attributedDescription: NSAttributedString) {
        self.attributedDescription = attributedDescription
    }
}
