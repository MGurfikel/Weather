//
//  moreDetailsView.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/27/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class moreDetailsView: UIView {

    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak  var pressure: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var sunRise: UILabel!
    @IBOutlet weak var sunSet: UILabel!
    
    
    
    func configure(with city : City){
        
    
   /////////////
        if let humidity = city.humidity{
        self.humidity.text = "Humidity: " + humidity + "%"
        }
        if let pressure = city.pressure{
           self.pressure.text = "Pressure: "+pressure+" mbar"
        }
        if let visibility = city.visibility{
        self.visibility.text = "Visibility: " + visibility + " m"
        
        }
        
            self.sunSet.text = city.sunSetString
    
        
            self.sunRise.text = city.sunRiseString
      
        
        
        if let darkBG = AppManager.manager.darkBackground {
            self.changeViewColor(darkBackground: darkBG, tag: 0)
        }
        

        
        
    }

}
