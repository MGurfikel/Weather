



import Foundation
import Alamofire

class APIManager{
    
    static let shared = APIManager()
    
    private let baseURL = "http://api.openweathermap.org"
    private let apiKey = "74e1ab619be9de88a112372ca6abb081"
    
    
    typealias Callback = (_ arr : [City], _ err : Error?) -> Void
    
  
    func getCity(lat: String, lon: String, callback : @escaping Callback)
    {
        let params : [String:Any] = [
            "appid":self.apiKey,
            "lat":lat,
            "lon":lon
            
        ]
        
      
        let url = "http://api.openweathermap.org/data/2.5/weather"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (dataRes) in
            
            guard let json = dataRes.result.value as? [String:Any] else{
                
                
                callback([], dataRes.error)
                return
            }
            
            
            let results : [[String:Any]]
            
            
              results = [json]
          
            
            
            let arr : [City] = results.flatMap{City($0)}
            print(arr)
            callback(arr, nil)
        
        }
    }
    typealias Callback2 = (_ arr : [DetailedCity], _ err : Error?) -> Void
    
    
    func getFiveDayForecast(lat: String, lon: String, callback : @escaping Callback2)
    {
        let params : [String:Any] = [
            "appid":self.apiKey,
            "lat":lat,
            "lon":lon
        ]
        
      
        let url = "http://api.openweathermap.org/data/2.5/forecast"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (dataRes) in
            
            guard let json = dataRes.result.value as? [String:Any] else{
                callback([], dataRes.error)
                return
            }
            
        
            let list = json["list"] as? [[String:Any]] ?? []
 
          let arr : [DetailedCity] = list.flatMap{DetailedCity($0)}
            print(arr)
            callback(arr, nil)
   
        }
    }

    
    
}
