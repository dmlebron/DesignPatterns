//
//  ImageLoader.swift
//
//  Created by david martinez on 3/2/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

protocol ImageLoading {
    func load(url: URL?, completion: @escaping ImageLoader.Completion)
}

final class ImageLoader: ImageLoading {
    typealias Completion = (UIImage?) -> Void
    private let imageCache: ImageCaching
    
    init(imageCache: ImageCaching) {
        self.imageCache = imageCache
    }
    
    func load(url: URL?, completion: @escaping Completion) {
        guard let url = url else { return completion(nil) }
        
        if let cachedImage = cachedImage(url: url) {
            completion(cachedImage)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache(url: url, image: image)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

// MARK: - Private Helper Methods
private extension ImageLoader {
    func cache(url: URL, image: UIImage) {
        imageCache.setImage(image, forKey: url.absoluteString)
    }
    
    func cachedImage(url: URL) -> UIImage? {
        return imageCache.imageForKey(url.absoluteString)
    }
}
