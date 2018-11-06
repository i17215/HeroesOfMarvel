//
//  HeroesOfMarvelTests.swift
//  HeroesOfMarvelTests
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import XCTest
@testable import HeroesOfMarvel
import CoreData

class HeroesOfMarvelTests: XCTestCase {
    
    var listOfHeroesViewController: ListOfHeroesViewController!

    override func setUp() {
        super.setUp()
        
        listOfHeroesViewController = ListOfHeroesViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Check entity in Core Data
    func testCoreDataIsEmpty() {
        XCTAssertTrue(listOfHeroesViewController.coreDataIsEmpty)
    }
    
    /// Check how many objects in Core Data
    func testCoreDataEntitiesCount() {
        let context = listOfHeroesViewController.appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarvelHero")
        
        do {
            let count  = try context.count(for: request)
            
            XCTAssertEqual(10, count)
        } catch {
            print(error.localizedDescription)
        }
    }
}
