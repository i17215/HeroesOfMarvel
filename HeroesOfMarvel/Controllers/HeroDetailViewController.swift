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
    private var coreDataHero: MarvelHero?
    
    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hero != nil {
            nameLabel.text = hero?.name
            
            if hero?.description == "" {
                descriptionText.text = "Description not available"
            } else {
                descriptionText.text = hero?.description
            }
            
            image.kf.setImage(with: hero?.thumbnail.url)
        } else {
            image.image = UIImage(named: "placeholder")
            nameLabel.text = coreDataHero?.heroName
            
            if coreDataHero?.heroStory == "" {
                descriptionText.text = "Description not available"
            } else {
                descriptionText.text = coreDataHero?.heroStory
            }
        }
    }
}

extension HeroDetailViewController {
    
    /// Function that instantiate view controller and get data for the properties
    static func instantiate(hero: Hero) -> HeroDetailViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeroDetailViewController") as? HeroDetailViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }
        
        vc.hero = hero
        
        return vc
    }
    
    /// Function that instantiate view controller and get data for the properties
    static func instantiate(coreDataHero: MarvelHero) -> HeroDetailViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HeroDetailViewController") as? HeroDetailViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }
        
        vc.coreDataHero = coreDataHero
        
        return vc
    }
}
