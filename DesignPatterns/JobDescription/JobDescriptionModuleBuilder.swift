//
//  JobDescriptionModuleBuilder.swift
//  DesignPatterns
//
//  Created by david martinez on 2/27/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct JobDescriptionModuleBuilder {
    func module(attributedDescription: NSAttributedString) -> UIViewController {
        let view = UIStoryboard.detail.instantiateViewController(withIdentifier: JobDescriptionViewController.storyboardIdentifier) as! JobDescriptionViewController
        view.set(attributedDescription: attributedDescription)
        return view
    }
}
