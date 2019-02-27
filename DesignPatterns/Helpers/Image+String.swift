//
//  Image+String.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

extension URL {
    private var cachingKey: String {
        return absoluteString
    }

    func loadImage(_ completion: @escaping (UIImage?) -> Void) {
        if let image = CurrentEnvironment.imageCache.imageForKey(cachingKey) {
            completion(image)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: self), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            CurrentEnvironment.imageCache.setImage(image, forKey: self.cachingKey)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
