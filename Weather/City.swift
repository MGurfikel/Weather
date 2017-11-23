//
//  City.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/5/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import Foundation


class City{
    let id : Int32!
    let temp : String?
    let country : String?
    let city : String?
    let pressure : String?
    let humidity : String?
    let maxTemp : String?
    let minTemp : String?
    let description : String?
    let windSpeed : String?
    let windDir : String?
    let sunRiseMillis : Int?
    let sunSetMillis : Int?
    let sunSetString : String?
    let sunRiseString : String?
    let visibility: String?
    let day : Bool?
  
    
    
    init?(_ dict : [String:Any]) {
        guard let id = dict["id"] as? Int32 else{
            return nil
        }
        self.id = id
        //////
        if let sys = dict["sys"] as? [String:Any]{
            if let country = sys["country"] as? String{
            self.country = country
            }else{
                self.country = nil
            }
            /////////////
            var sunSet : Int?
            var sunRise : Int?
            if let sunset = sys["sunset"] as? Int {
                sunSet = sunset
                self.sunSetMillis = sunSet
                let sunSetDate = Date(timeIntervalSince1970: (TimeInterval(sunSet!)))
                if let timezone = AppManager.manager.timeZoneUtils{
                let sunSetTime = AppManager.manager.getCurrentTime(date: sunSetDate, timeZone: timezone, dateBool: false)
                AppManager.manager.generalSunSet = sunSetTime
                self.sunSetString = sunSetTime
                }else{
                    self.sunSetString = nil
                }
            }else{
                self.sunSetMillis = nil
                self.sunSetString = nil
            }
            
            
            
            if let sunrise = sys["sunrise"] as? Int {
                sunRise = sunrise
                self.sunRiseMillis = sunrise
                let sunRiseDate = Date(timeIntervalSince1970: (TimeInterval(sunrise)))
                if let timezone = AppManager.manager.timeZoneUtils{
                let sunRiseTime = AppManager.manager.getCurrentTime(date: sunRiseDate, timeZone: timezone, dateBool: false)
                AppManager.manager.generalSunRise = sunRiseTime
                self.sunRiseString = sunRiseTime
                }else{
                    self.sunRiseString = nil
                }
            }else{
                self.sunRiseMillis = nil
                self.sunRiseString = nil
                
                
            }
            if sunRise != nil, sunSet != nil  {
                let dayOrNight = AppManager.manager.dayOrNight(sunSet: sunSet!, sunRise: sunRise!)
                self.day = dayOrNight
            }else{
              self.day = nil
            }
            
            
       
            
            
        }else{
            self.country = nil
            self.sunSetMillis = nil
            self.sunSetString = nil
            self.sunRiseMillis = nil
            self.sunRiseString = nil
            self.day = nil
            
            
        }
        ////////
        if let city = dict["name"] as? String{
        self.city = city
        }else{
            
            self.city = nil
        }
        ///////////
        
        //////////
        if let main = dict["main"] as? [String:Any] {
            if let tempDouble = main["temp"] as? Double{
               self.temp = tempDouble.setTemp(AppManager.manager.celcius)
            }else{
                self.temp = nil
            }
            if let pressure = main["pressure"] as? Double{
                self.pressure = String(pressure)
            }else{
                self.pressure = nil
            }
            if let humidity = main["humidity"] as? Int{
                self.humidity = String(humidity)
            }else{
                self.humidity = nil
            }
            if let maxTempDouble = main["temp_max"] as? Double{
                self.maxTemp = maxTempDouble.setTemp(AppManager.manager.celcius)
                
            }else{
                self.maxTemp = nil
            }
            if let minTempDouble = main["temp_min"] as? Double{
                self.minTemp = minTempDouble.setTemp(AppManager.manager.celcius)
            }else{
                self.minTemp = nil
            }
        }else{
            self.temp = nil
            self.pressure = nil
            self.humidity = nil
            self.maxTemp = nil
             self.minTemp = nil
            
        }
  
   
        if let visibility = dict["visibility"] as? Int{
            self.visibility = "\(visibility)"
        }else{
            self.visibility = nil
        }
        
        //////////
        if let weather = dict["weather"] as? [[String:Any]]{
            let firstIndexWeather = weather[0]
                if let desc = firstIndexWeather["description"] as? String{
                    self.description = desc
                }else{
                    self.description = nil
            }
        }else{
            self.description = nil
        }
     
        /////////
        if let wind = dict["wind"] as? [String:Any] {
            if let speed = wind["speed"] as? Double{
            self.windSpeed = String(speed)
            }else{
                self.windSpeed = nil
            }
            if let windDeg = wind["deg"] as? Double{
                self.windDir = windDeg.convertDegToDir()
            }else{
                self.windDir = nil
            }
            
        }else{
            self.windDir = nil
            self.windSpeed = nil
        }
       
    
        ///////////
       

    }
    
}

class DetailedCity{
    

   
    let temp : String?
     let desc : String?
    let date: String?
    let day : Bool?
     let time : String?
    let timeInMillis : Int?
    let weekday : String?
    let weekdayInt : Int?

   init?(_ dict: [String : Any]) {
    
   if let main = dict["main"] as? [String : Any] {
    if let temp = main["temp"] as? Double{
        self.temp = temp.setTemp(AppManager.manager.celcius)
    }else{
        self.temp = nil
    }
   }else{
    self.temp = nil
    }
    
    
    
    
    ///////
   //////////////
    if let timeMillis = dict["dt"] as? Int, AppManager.manager.timeZoneUtils != nil{
        self.timeInMillis = timeMillis
        let timeDate = Date(timeIntervalSince1970: (TimeInterval(timeInMillis!)))
        if let timezone = AppManager.manager.timeZoneUtils{
        let timeTime = AppManager.manager.getCurrentTime(date: timeDate, timeZone: timezone, dateBool: false)
        let timeDateTime = AppManager.manager.getCurrentTime(date: timeDate, timeZone: AppManager.manager.timeZoneUtils!, dateBool: true)
        self.time = timeTime
        self.date = timeDateTime
        self.weekdayInt = AppManager.manager.getWeekday(date: timeDateTime)
            if self.weekdayInt != nil{
           self.weekday = AppManager.Weekday(rawValue: weekdayInt!)?.name
            }else{
                self.weekday = nil
            }
        if let day = AppManager.manager.checkIfDay(time: timeTime){
            self.day = day
        }else{
            self.day = nil
            }}else{
            self.time = nil
            self.date = nil
            self.weekdayInt = nil
            self.weekday = nil
             self.day = nil
        }
    }else{
        self.timeInMillis = nil
        self.time = nil
        self.date = nil
        self.weekdayInt = nil
        self.weekday = nil
        self.day = nil
    }
    
   
    ////////
    
    

    if let weather = dict["weather"] as? [[String:Any]]{
        let d1 = weather[0]
        if let desc = d1["description"] as? String{
        self.desc = desc
    }else{
        self.desc = nil
        
    }
    }else{
        self.desc = nil
    }
}
}

class weekCity{
    
    var maxTemp : String!
    var minTemp : String!
    var day : String!
    var desc : String?
    var date: String!
    
    init?(_ dict: [String : Any]) {
        
        
        let date = dict["date"] as! String
        self.date = date
        
        let highTemp = dict["maxTemp"] as! Int
            self.maxTemp = String(highTemp)
    
       let lowTemp = dict["minTemp"] as! Int
            self.minTemp = String(lowTemp)
      
        self.day = dict["weekday"] as! String
        self.desc = dict["description"] as? String
        
        
        
    }
    
    
    

    
    
    
    
    
}


