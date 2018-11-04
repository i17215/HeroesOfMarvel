//
//  HeroTableViewCell.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import UIKit
import Kingfisher

class HeroTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier = "HeroCell"
    
    // MARK: - Outlets
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    /// Configure cell
    public func configureWith(_ hero: Hero) {
        nameLabel.text = hero.name
        
        imageThumbnail.kf.setImage(with: hero.thumbnail.url,
                                   options: [.transition(.fade(0.3))])
    }
}
