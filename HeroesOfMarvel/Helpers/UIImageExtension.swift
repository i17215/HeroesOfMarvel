//
//  UIImageExtension.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 06/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
