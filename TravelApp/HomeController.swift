//
//  ViewController.swift
//  TravelApp
//
//  Created by Pankaj Rawat on 21/01/17.
//  Copyright © 2017 Pankaj Rawat. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sharedData = SharedData()
    var trips: [Trip]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(TripCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        
        setUpNavBarButtons()
        
        if sharedData.getToken() == "" {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchTrips()
        }
        
        setUpMenuBar()
    }
    
    func handleLogout() {
        sharedData.clearAll()
        let loginController = LoginController()
        loginController.homeController = self
        present(loginController, animated: true, completion: nil)
        
    }
    
    func setUpNavBarButtons() {
        
        // Left Navigation Bar Button
        let searchIcon = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate)
        let searchBarButtonItem = UIBarButtonItem(image: searchIcon, landscapeImagePhone: searchIcon, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButtonItem.tintColor = UIColor.darkGray
        
        let navMoreIcon = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        let moreBarButtonItem = UIBarButtonItem(image: navMoreIcon, landscapeImagePhone: navMoreIcon, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = UIColor.darkGray
        
        
        navigationItem.leftBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
        // Left Navigation Bar Button
        let addIcon = UIImage(named: "plus-filled")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: #selector(publishTrip))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appSecondaryColor()
    }
    
    func publishTrip() {
        let createTripController = CreateTripController()
        navigationController?.pushViewController(createTripController, animated: true)
    }
    
    func handleSearch() {
        print(123)
    }
    
    let settingsLauncher = SettingsLauncher()
    func handleMore() {
        settingsLauncher.homeController = self
        settingsLauncher.showSettings()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setUpMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    func fetchTrips() {
        TripService.sharedInstance.fetchTrips { (trips: [Trip]) in
            self.trips = trips
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! TripCell
        cell.trip = trips?[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

