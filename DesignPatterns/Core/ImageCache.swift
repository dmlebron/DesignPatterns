//
//  Image+NSCache.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol Caching {
    associatedtype Object: Cachable
    func set(object: Object, key: CachingKey)
    func object(key: CachingKey) -> Object?
}

protocol ImageCaching {
    func setImage(_ image: UIImage, forKey key: String)
    func imageForKey(_ key: String) -> UIImage?
}

final class ImageCache: Caching {
    typealias Object = UIImage
    
    private let cache = NSCache<NSString, UIImage>()
    
    func set(object: UIImage, key: CachingKey) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func object(key: CachingKey) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

// MARK: - ImageCaching
extension ImageCache: ImageCaching {
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

extension UIImage: Cachable {
    var cachingKey: String {
        return ""
    }
}
