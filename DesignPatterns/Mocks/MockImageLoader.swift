//
//  MockImageLoader.swift
//  DesignPatterns
//
//  Created by david martinez on 3/2/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//
import UIKit

class MockImageLoader: ImageLoading {
    private var expectedImage: UIImage?
    var url: URL?
    func load(url: URL?, completion: @escaping ImageLoader.Completion) {
        self.url = url
        completion(expectedImage)
    }
}

// MARK: - Configuration Helper
extension MockImageLoader {
    func configureCompletion(image: UIImage) {
        expectedImage = image
    }
}
