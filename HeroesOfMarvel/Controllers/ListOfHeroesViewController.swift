//
//  ViewController.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import UIKit
import Moya
import CoreData
import Kingfisher

class ListOfHeroesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var marvelHeroes = [MarvelHero]() // This Array used only when no network connection
    private var heroes = [Hero]()
    let provider = MoyaProvider<Marvel>()
    
    var coreDataIsEmpty: Bool {
        do {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarvelHero")
            let count  = try context.count(for: request)
            return count == 0 ? true : false
        } catch {
            return true
        }
    }

    // MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageView.isHidden = true
        
        if coreDataIsEmpty && Reachability.isConnectedToNetwork() == false {
            let alertController = UIAlertController(title: "No network", message: "To continue using this app you need to check your internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { action in
                self.messageView.isHidden = true
            }

            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        } else if !coreDataIsEmpty && Reachability.isConnectedToNetwork() == false {
            presentDataAboutHeroFromCoreData()
        } else {
            setupActivityIndicator()
            
            provider.request(.getHeroes) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(MarvelResponse<Hero>.self).data.results
                        self?.heroes = data
                        
                        for hero in data[0..<10] {
                            
                            DispatchQueue.global().async {
                                
                                let imageUrl = hero.thumbnail.url
                                let imageData = try? Data(contentsOf: imageUrl)
                                
                                DispatchQueue.main.async {
                                    self?.saveHeroesWith(heroName: hero.name, heroStory: hero.description, thumbnail: imageData!)
                                }
                            }
                        }
                        
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
    }
    
    // MARK: - Methods
    
    /// Function that setup activity indicator and set it to message view
    private func setupActivityIndicator() {
        messageView.isHidden = false
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = messageView.center
        activityIndicator.startAnimating()
        self.messageView.addSubview(activityIndicator)
    }
    
    /// Function that save information about marvel heroes in Core Data
    private func saveHeroesWith(heroName: String, heroStory: String, thumbnail: Data) {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MarvelHero", in: context)
        
        let marvelHero = NSManagedObject(entity: entity!, insertInto: context) as! MarvelHero
        marvelHero.heroName = heroName
        marvelHero.heroStory = heroStory
        marvelHero.thumbnail = thumbnail
        
        do {
            try context.save()
            marvelHeroes.append(marvelHero)
            print("Data was saved correctly!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Function that present data about marvel heroes that stored in Core Data
    func presentDataAboutHeroFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MarvelHero> = MarvelHero.fetchRequest()
        
        do {
            marvelHeroes = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteAllData(_ entity: String) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}

// MARK: - UITableView Delegate & Data Source
extension ListOfHeroesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Reachability.isConnectedToNetwork() == false {
            return marvelHeroes.count
        } else {
            return heroes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.reuseIdentifier, for: indexPath) as? HeroTableViewCell ?? HeroTableViewCell()
        
        if Reachability.isConnectedToNetwork() == false {
            let hero = marvelHeroes[indexPath.item]
            
            cell.nameLabel.text = hero.heroName
            
            let img = UIImage(data: hero.thumbnail!)
            cell.imageThumbnail.image = img ?? UIImage(named: "placeholder")
        } else {
            cell.configureWith(heroes[indexPath.item])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if Reachability.isConnectedToNetwork() == false {
            let heroDetailVC = HeroDetailViewController.instantiate(coreDataHero: marvelHeroes[indexPath.item])
            navigationController?.pushViewController(heroDetailVC, animated: true)
        } else {
            let heroDetailVC = HeroDetailViewController.instantiate(hero: heroes[indexPath.item])
            navigationController?.pushViewController(heroDetailVC, animated: true)
        }
    }
}
