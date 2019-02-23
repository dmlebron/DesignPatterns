//
//  App+Storyboard.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var detail: UIStoryboard {
        return UIStoryboard(name: "Detail", bundle: nil)
    }
}
