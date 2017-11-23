//
//  ForecastCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/7/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var forecastImg: UIImageView!
    @IBOutlet weak var forecastDate: UILabel!
    @IBOutlet weak var forecastTemp: UILabel!
    
    func configure(with dCity : DetailedCity){
  
        
   
        self.forecastDate.text = dCity.time
       if let temp = dCity.temp{
        self.forecastTemp.text = temp + AppManager.manager.cORf
        }
        
        
        let itemName = AppManager.manager.getWeatherImage(with: dCity.desc, day: dCity.day)
        self.forecastImg.image = UIImage(named: itemName)
      
        

        
        
    }
 
    
    
}
