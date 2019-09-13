//
//  NSRange+TextField.swift
//  DesignPatterns
//
//  Created by david martinez on 9/13/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation

extension NSRange {
    var isBackspacing: Bool {
        return length == 1
    }
}
