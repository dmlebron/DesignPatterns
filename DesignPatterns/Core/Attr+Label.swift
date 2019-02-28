//
//  Attr+Label.swift
//  DesignPatterns
//
//  Created by david martinez on 2/27/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = attributedText as NSAttributedString? else { return false }
        let size = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let labelTextSize = labelText.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
