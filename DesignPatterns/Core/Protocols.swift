//
//  Protocols.swift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

// MARK - ViewCustomizing
protocol ViewCustomizing {
    func customize()
    func setupUI()
    func addSubviews()
    func addConstraints()
    func setupSelectors()
    func additionalSetup()
}

extension ViewCustomizing {
    func customize() {
        setupUI()
        setupSelectors()
        addSubviews()
        addConstraints()
        additionalSetup()
    }
    
    func setupSelectors() {}
    func addSubviews() {}
    func addConstraints() {}
    func additionalSetup() {}
}

// MARK - CellRegistration
protocol CellRegistration where Self: UITableViewCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension CellRegistration {
    private static var name: String {
        return String(describing: Self.self)
    }
    static var identifier: String {
        return name
    }
    
    static var nib: UINib {
        return UINib(nibName: name, bundle: nil)
    }
}

// MARK: - CellDisplaying
protocol CellDisplaying {
    associatedtype ViewData
    
    func setup(viewData: ViewData)
}
