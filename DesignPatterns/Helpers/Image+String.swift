//
//  Image+String.swift
//  DesignPatterns
//
//  Created by david martinez on 2/23/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import UIKit

extension String {
    func image(_ completion: @escaping (UIImage?) -> Void) {
        if let image = CurrentEnvironment.imageCache.imageForKey(self) {
            completion(image)
            return
        }
        
        guard let url = URL(string: self) else {
            return completion(nil)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return completion(nil) }
            CurrentEnvironment.imageCache.setImage(image, forKey: self)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
