//
//  SearchTableCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/20/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {


    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    func configure (with location : Location){
  
        
        
     
            cityLabel.text? = location.city!
            countryLabel.text? = location.state!
        
    }
    
    func configureLastReaserch (with location : LastReasearch){
        
        
        cityLabel.text? = location.city!
        countryLabel.text? = location.state!
        
        
        
    }
}
