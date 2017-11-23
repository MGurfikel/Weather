//
//  Location+utils.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/16/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import Foundation

extension Location{
    convenience init?(_ dict : [String:Any]){
        guard let city = dict["name"] as? String, !city.isEmpty else{
            return nil
        }
        
        
        guard let country = dict["country"] as? String, !country.isEmpty else{
            return nil
        }
        
        guard let coord = dict["coord"] as? [String : Any],
            let lat = coord["lat"] as? Double,
            let lon = coord["lon"] as? Double
        else{
            return nil
        }
        
        guard let _id = dict["id"] as? Int32 else{
            return nil
        }
        
        self.init(context: DBManager.manager.context)
        self.city = city
        self.state = country
        self.latitude = lat
        self.longitude = lon
        self.id = _id

        DBManager.manager.saveContext()
    }
}
