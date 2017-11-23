//
//  WeekForecastCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/8/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class WeekForecastCell: UITableViewCell {
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forecastImg: UIImageView!
    @IBOutlet weak var tempsLabel: UILabel!
    
    
    func configure(with weekCity : weekCity){
      
        
        
        
       let max = weekCity.maxTemp
     let min = weekCity.minTemp
        
        self.tempsLabel.text = max! + "/" + min!
        self.dayLabel.text = weekCity.day
        
        
        let itemName = AppManager.manager.getWeatherImage(with: weekCity.desc, day: true)
        self.forecastImg.image = UIImage(named: itemName)
       
        
        if let darkBG = AppManager.manager.darkBackground {
            self.changeViewColor(darkBackground: darkBG, tag: 0)
        }
        

        
    }

}
