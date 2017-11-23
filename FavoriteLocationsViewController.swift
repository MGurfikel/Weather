//
//  FavoriteLocationsViewController.swift
//  
//
//  Created by Moran Gurfinkel on 10/12/17.
//
//

import UIKit

class FavoriteLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteLocationsArray = DBManager.manager.fetchFavoriteLocations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var favoriteLocationsArray : [FavoriteLocations] = []
    
    
        // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteLocationsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let city = favoriteLocationsArray[indexPath.row].city!
        let state = favoriteLocationsArray[indexPath.row].state!
        cell.textLabel?.text = city + ", " + state
        
        return cell
    }
  
}
