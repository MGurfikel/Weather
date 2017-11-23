//
//  utils.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/9/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import Foundation
import UIKit

class GeneralData{
    
    static let data = GeneralData()
 
     var firstLoad : Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "firstLoad")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.bool(forKey: "firstLoad")
            
        }
        
    }

    
    let boolTemp : Bool
    
    
    let isLTR : Bool
    
    private init() {
        isLTR = Locale.characterDirection(forLanguage: Locale.current.languageCode!) == .leftToRight
        boolTemp = UserDefaults.standard.bool(forKey: "celcius")
        
        
        
    }
}


