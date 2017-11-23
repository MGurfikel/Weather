//
//  DBHelper.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/16/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import Foundation


class DBHelper{
    private static var didLoadCities : Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "didLoadCities")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.bool(forKey: "didLoadCities")
            
        }
        
    }
    
    static func loadCities(){
        if didLoadCities{
            return
        }
        
        guard let file = Bundle.main.url(forResource: "city.list", withExtension: "json") else{
            print("file not found")
            return
            
        }
        guard let data = try? Data(contentsOf: file) else{
            print("failed to open file")
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else{
            return
        }
        guard let arr = json as? [[String:Any]] else{
            return
        }
        
        for dict in arr{
            _ = Location(dict)
        }
        
        
        DBManager.manager.saveContext()
        didLoadCities = true

        
        
    }
    
    
}
