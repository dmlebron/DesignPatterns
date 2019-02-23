//
//  Protocols.swift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import Foundation

protocol ViewCustomization {
    func viewLoaded()
    func setupUI()
    func addSubviews()
    func addConstraints()
    func setupSelectors()
}

extension ViewCustomization {
    func viewLoaded() {
        setupUI()
        setupSelectors()
        addSubviews()
        addConstraints()
    }
    
    func setupSelectors() {}
    func addSubviews() {}
    func addConstraints() {}
}
