//
//  ExtendedForecastCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/9/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class ExtendedForecastCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var forecastImg: UIImageView!
    
    
    func configure(with dCity : DetailedCity){
   
        
        self.dateLabel.text = dCity.time
        if let temp = dCity.temp{
        self.tempLabel.text = temp + AppManager.manager.cORf
        }
        if let desc = dCity.desc{
        let itemName = AppManager.manager.getWeatherImage(with: desc, day: dCity.day)
        self.forecastImg.image = UIImage(named: itemName)
        }
       
        

    }

}
