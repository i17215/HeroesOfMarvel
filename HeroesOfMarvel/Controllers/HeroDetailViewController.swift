//
//  HeroDetailViewController.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    // MARK: - Properties
    private var hero: Hero?
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = hero?.name
        
        if hero?.description == "" {
            descriptionText.text = "Description not available"
        } else {
            descriptionText.text = hero?.description
        }
        
        image.kf.setImage(with: hero?.thumbnail.url)
    }
}

extension HeroDetailViewController {
    
    /// Function that instantiate view controller and get data for the properties
    static func instantiate(hero: Hero) -> HeroDetailViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeroDetailViewController") as? HeroDetailViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }
        
        vc.hero = hero
        
        return vc
    }
}
