//
//  Protocols.swift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

protocol ViewCustomizing {
    func viewLoaded()
    func setupUI()
    func addSubviews()
    func addConstraints()
    func setupSelectors()
    func additionalSetup()
}

extension ViewCustomizing {
    func viewLoaded() {
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
