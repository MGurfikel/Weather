//
//  FirstCellView.swift
//  
//
//  Created by Moran Gurfinkel on 10/6/17.
//
//


import UIKit


class FirstCellView: UIView{
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak  var desc: UILabel!
    @IBOutlet weak var maxMinTemp: UILabel!
    @IBOutlet weak var wind: UILabel!
     @IBOutlet weak var date: UILabel!
    @IBOutlet weak var imgView: UIImageView!
 
    func configure(with city : City){
        if let temp = city.temp{
       self.temp.text = temp + AppManager.manager.cORf
        }
        if let maxTemp = city.maxTemp, let minTemp = city.minTemp{
            let strMax = "Max: " + maxTemp
            let strMIn = "Min: " + minTemp
            self.maxMinTemp.text = strMax + " ," + strMIn
        
        }
            desc.text = city.description
       
        let itemName = AppManager.manager.getWeatherImage(with: city.description, day: city.day)
        self.imgView.image = UIImage(named: itemName)//image cant be nil. otherwise it will crush when ill try change the colors of the subview. that beacause i pona directly to an image that doesnt exist. the label does. right? anyway, i palways provide image so thats ok. maybe i should do guard in the converting?
      
        if let windSpeed = city.windSpeed, let windDir = city.windDir{
       self.wind.text = "WIND: " + windDir + ", SPEED " + String(windSpeed)+" KPH"
        }
        //////////////
        if let timezone = AppManager.manager.timeZoneUtils{
      time.text = AppManager.manager.getCurrentTime(date: nil, timeZone: timezone, dateBool: false)//i guess it is less good than taking the time from api, because it can be unsynchronized...
        date.text = AppManager.manager.getCurrentTime(date: nil, timeZone: timezone, dateBool: true)
        }
        
       if let darkBG = AppManager.manager.darkBackground {
            self.changeViewColor(darkBackground: darkBG, tag: 0)
        }
        
        

}


        




}
