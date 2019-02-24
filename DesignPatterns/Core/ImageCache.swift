//
//  Image+NSCache.swift
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol ImageCaching {
    func setImage(_ image: UIImage, forKey key: String)
    func imageForKey(_ key: String) -> UIImage?
}

final class ImageCache: ImageCaching {
    private let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

