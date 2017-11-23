//
//  FavoriteLocationCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/21/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class FavoriteLocationCell: UITableViewCell {

  
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    func configure(with favLoc : FavoriteLocations){
      
        

        countryLabel.text = favLoc.state
        cityLabel.text = favLoc.city

        

       }
}
