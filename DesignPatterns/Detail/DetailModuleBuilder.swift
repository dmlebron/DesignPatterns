//
//  DetailModuleBuilder.swift
//
//  Created by David Martinez-Lebron on 2/25/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct DetailModuleBuilder {
    var module: UIViewController {
        let mainViewController = UIStoryboard.main.instantiateInitialViewController() as! MainViewController
        
        return mainViewController
    }
}
