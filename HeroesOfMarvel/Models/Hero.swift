//
//  Hero.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import Foundation

struct Hero: Codable {
    
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension Hero {
    
    struct Thumbnail: Codable {
        let path: String
        let `extension`: String
        
        var url: URL {
            return URL(string: path + "." + `extension`)!
        }
    }
}
