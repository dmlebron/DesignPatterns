//
//  Color.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

struct Theme {
    enum `Type` {
        case dark
        case light
    }
    
    private let type: Type
    private let color = Color()
    
    var backgroundColor: UIColor {
        switch type {
        case .dark: return color.darkGray
        case .light: return color.white
        }
    }
    
    var textSoftColor: UIColor {
        switch type {
        case .dark: return color.darkGray
        case .light: return color.white
        }
    }
    
    var textStrongColor: UIColor {
        switch type {
        case .dark: return color.darkGray
        case .light: return color.white
        }
    }
}

struct Color {
    var darkGray: UIColor {
        return UIColor(red: 45/255, green: 49/255, blue: 66/255, alpha: 1)
    }
    
    var softRed: UIColor {
        return UIColor(red: 239/255, green: 131/255, blue: 84/255, alpha: 1)
    }
    
    var softGray: UIColor {
        return .systemGroupedBackground
    }
    
    var white: UIColor {
        return .white
    }
}
