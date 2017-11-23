//
//  AppManager.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/24/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit
import CoreLocation
import APTimeZones

extension Notification.Name{
    static var locationFound : Notification.Name{
        get{
            return Notification.Name(rawValue: "locationfoundnotifiacation")
        }
    }
}

class AppManager: NSObject, CLLocationManagerDelegate {
    
    
    static let manager = AppManager()
    
    var locationFromClass : CLLocation!
    private let locationManager : CLLocationManager
    var locManager : CLLocationManager!
    var location: CLLocation?{
       return self.locationFromClass
        }
    ///////////////
    var lastLongitude : String?
    var lastLatitude : String?
    var lastId : Int32?
    var celcius : Bool = GeneralData.data.boolTemp{
        didSet{
            celcius ? (cORf = "°c") : (cORf = "°F")
        }
    }
    
    var generalSunSet : String?
    var generalSunRise : String?
    var cORf : String = "°c"
    
    var globalTimeZoneMillis : Int {
        get{
            
            let date = Date()
            let timeInterval = date.timeIntervalSince1970
            return Int(timeInterval)
        }
        
    }
    
   
    var errorGPS : Bool?
    
    var darkBackground : Bool?
    var imageBackground : String?
    var dy : Bool?
     
    
    var timeZoneUtils : TimeZone?
    var globalDate : Date?
    //////////////
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locationFromClass = (locations).last
        locationManager.stopUpdatingLocation()
        print("me print")
        NotificationCenter.default.post(name: .locationFound, object: self)
        print("me print")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorGPS = true
        print(error)
        print("errrror")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    
    func startLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() {
            switch(authStatus) {
            case .notDetermined:
                print("No access")
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                print("denied")
            case .restricted:
                print("restricted")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
        }
        
       
 
        
        
    }
    
    
    
    
    enum Weekday : Int{
        case Sunday = 1
        case Monday = 2
        case Tuesday = 3
        case Wednesday = 4
        case Thursday = 5
        case Friday = 6
        case Saturday = 7
        
        var name : String{
            get{
                switch self{
                case .Sunday : return "Sunday"
                case .Monday : return "Monday"
                case .Tuesday : return "Tuesday"
                case .Wednesday : return "Wednesday"
                case .Thursday : return "Thursday"
                case .Friday : return "Friday"
                case .Saturday : return "Saturday"
               
                    
                    
                }
            }
        }
        
        
    }
    
    func getDay(day : String)->Int{
        switch day{
        case "Sunday" : return 1
        case "Monday" : return 2
        case "Tuesday" : return 3
        case "Wednesday" : return 4
        case "Thursday": return 5
        case "Friday" : return 6
        case "Saturday" : return 7
        default : return 0
            
        }
        
    }
    
    
    
    
    
    func getTimeZone(lat: String, lon: String){

        guard let latDouble = Double(lat) else{
            return
        }
        guard let lonDouble = Double(lon) else{
            return
        }
        let location = CLLocation(latitude: latDouble, longitude: lonDouble)
        let timeZone : TimeZone = location.timeZone()
        timeZoneUtils = timeZone
       
 
        
        
        
    }
    
    
    func getCurrentTime(date: Date?, timeZone : TimeZone = .current, dateBool : Bool)->String{
        
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        
        var recievedDate : Date
        
            if date == nil{
                recievedDate = Date()
            }else{
            recievedDate = date!
        }
     
        if dateBool{
             formatter.dateFormat = "yyyy-MM-dd"
            
        }else{
        
        formatter.dateFormat = "HH:mm"
            
    
        }
        return formatter.string(from: recievedDate)

        
        
 
    }
  
    
    
    func createAlert(title: String, message : String) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
      return alert
    }
    
    
    
    
    
    
      //day is true, night is false
    func dayOrNight(sunSet : Int, sunRise : Int) -> Bool{
        let sunSet = sunSet
        let sunRise = sunRise
        if globalTimeZoneMillis > sunSet || globalTimeZoneMillis < sunRise{//// deal with the optional!
            return false
        }else{
            return true
        }
        
    }
    
    
    
    func getBackgroundImage(desc: String?, day: Bool?)->String{
        guard let day = day, let desc = desc else{
             return "beautifulday"
        }
      
        if desc == "clear sky" || desc.contains("clouds"){
            darkBackground = day ? false : true
            return day ? "beautifulvillage" : "clearskynight"
            
        }
        if desc.contains("thunderstorm") {
            darkBackground = true
            return "thunderwallpaper"
        }
        if desc.contains("snow") || desc.contains("sleet"){
            darkBackground = false
            return "snowwallpaper"
        }
        if desc.contains("rain") || desc.contains("drizzle") {
            darkBackground = false
            
            return "rainyday"
        }
        if desc=="mist" || desc=="smoke" || desc=="haze" || desc=="sand" || desc == "dust" || desc == "whirls" || desc=="fog" || desc=="sand" || desc=="dust" || desc=="volcanic ash" || desc=="squalls" || desc=="tornado"{
            
            darkBackground = false
            return "fogyday"
        }else{
            darkBackground = false
            return "beautifulday"
        }
        
        
        
    }
    
    func getWeekday(date: String) -> Int?{
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
        
        
        
        
    }
    
    
    func checkIfDay(time: String)->Bool?{
        let time = time
        guard let currentTimeArr = time.getIntFromString(seperator: ":", values: 2) else{
            return nil
        }
        guard let generalSunsetArr = generalSunSet?.getIntFromString(seperator: ":", values: 2) else{/////to check about generalsunset
            return nil
        }
        guard let generalSunriseArr = generalSunRise?.getIntFromString(seperator: ":", values: 2) else{/////to check about generalsunrise
            return nil
        }
        
        let currentHour = currentTimeArr[0]
        let currentMinute = currentTimeArr[1]
        ////
        let sunriseHour = generalSunriseArr[0]
        let sunriseMinute = generalSunriseArr[1]
        /////
        let sunsetHour = generalSunsetArr[0]
        let sunsetMinute = generalSunsetArr[1]
        ////////////
        
        if currentHour > sunsetHour || currentHour < sunriseHour{
            return false
            
        }
        if currentHour < sunsetHour && currentHour > sunriseHour{
            
            return true
            
            
        }else{
            if currentHour == sunsetHour{
                if currentMinute < sunsetMinute{
                    return true
                }else{/// either if it equals
                    return false
                }
                
            }else{///currenthour==sunrisehour
                
                if currentMinute < sunriseMinute{
                    return false
                }else{/// either if it equals
                    return true
                    
                    
                }
                
                
            }
            
        }
    
    }
    
    
    
    func getWeatherImage(with desc: String?, day : Bool?)->String{
        guard let desc = desc, !desc.isEmpty, let day = day else{
            return "no_item"
        }
        if desc == "clear sky" && !day{
            return "icons8-bright_moon"
            
            
        }
        if desc == "clear sky" && day{
            
            return "icons8-sun"
            
        }
        if desc.contains("thunderstorm"){
            return "icons8-cloud_lighting-1"
            
            
        }
        if desc.contains("thunderstorm") && desc.contains("rain"){
            return "icons8-storm"
            
            
        }
        if desc.contains("drizzle") || desc=="light rain" || desc == "moderate rain"{
            
            return "icons8-rain"
            
        }
        if desc.contains("rain"){
            
            return "icons8-torrential_rain"
            
        }
        if desc.contains("snow") && desc.contains("rain") || desc.contains("sleet"){
            
            return "icons8-sleet"
            
            
        }
        if desc.contains("snow"){
            
            return "icons8-light_snow"
            
        }
        if desc=="mist" || desc=="smoke" || desc=="haze" || desc=="sand" || desc == "dust" || desc == "whirls" || desc=="fog" || desc=="sand" || desc=="dust" || desc=="volcanic ash" || desc=="squalls" || desc=="tornado"{
            
            return "icons8-dust"
            
        }
        if desc=="few clouds" && day{
            
            return "icons8-partly_cloudy_day"
            
        }
        if desc=="few clouds" && !day{
            
            return "icons8-partly_cloudy_night"
            
        }
        if desc.contains("clouds") {
            
            return "icons8-clouds-1"
            
        }
        else{
            return "no_item"
        }
        
        
        
    }
  
    
    
   
    
    

}
