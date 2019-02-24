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
        guard let url = URL(string: self) else {
            return completion(nil)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else { return completion(nil) }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
