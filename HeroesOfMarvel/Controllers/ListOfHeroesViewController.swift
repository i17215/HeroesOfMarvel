//
//  ViewController.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import UIKit
import Moya

class ListOfHeroesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var heroes = [Hero]()
    let provider = MoyaProvider<Marvel>()

    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        
        provider.request(.getHeroes) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MarvelResponse<Hero>.self).data.results
                    self?.heroes = data
                    self?.activityIndicator.stopAnimating()
                    self?.messageView.isHidden = true
                    self?.tableView.reloadData()
                } catch let error {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Methods
    
    /// Function that setup activity indicator and set it to message view
    private func setupActivityIndicator() {
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = messageView.center
        activityIndicator.startAnimating()
        self.messageView.addSubview(activityIndicator)
    }
}

// MARK: - UITableView Delegate & Data Source
extension ListOfHeroesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.reuseIdentifier, for: indexPath) as? HeroTableViewCell ?? HeroTableViewCell()
        
        cell.configureWith(heroes[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let heroDetailVC = HeroDetailViewController.instantiate(hero: heroes[indexPath.item])
        navigationController?.pushViewController(heroDetailVC, animated: true)
    }
}
