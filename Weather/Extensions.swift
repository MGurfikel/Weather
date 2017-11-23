//
//  Extensions.swift
//  Weather
//
//  Created by Moran Gurfinkel on 11/2/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import Foundation
import UIKit


extension Double{
    
    
    func convertDegToDir() -> String{
        if self > 5 && self < 40 {
            return "North, North East"
            
        }
        if self >= 40 && self <= 50{
            return "North East"
        }
        if self > 50 && self < 85 {
            return "East, North East"
        }
        if self >= 85 && self <= 95{
            return "East"
        }
        if self > 95 && self < 130 {
            return "East, South East"
        }
        if self >= 130 && self <= 140{
            return "South East"
        }
        if self > 140 && self < 175 {
            return "South, South East"
        }
        if self >= 175 && self <= 185{
            return "South"
        }
        if self > 185 && self < 220 {
            return "South, South West"
        }
        if self >= 220 && self <= 230{
            return "South West"
        }
        if self > 230 && self < 265 {
            return "West, South West"
        }
        if self >= 265 && self <= 275{
            return "West"
        }
        if self > 275 && self < 310 {
            return "West, North West"
        }
        if self >= 310 && self <= 320{
            return "North West"
        }
        if self > 312 && self < 355 {
            return "North, North West"
        }
        if self >= 355 || self <= 5 {
            return "North"
        }
        else{
            return ""
        }
        
        
    }
    
    
    func setTemp(_ celcius : Bool) -> String{
      
        var doubleTemp : Double
        if celcius{
            doubleTemp = self - 273
        }else{
            doubleTemp = self * 9 / 5 - 459.67
        }
        var intTemp : Int = 0
        
        if (doubleTemp-0.5)>Double(Int((doubleTemp))){
            intTemp = Int(doubleTemp + 1.0)
            return String(intTemp)
            
        }else{
            intTemp = Int(doubleTemp)
            return String(intTemp)
        }

        
    }
    
    
    

    func convertToCtoF(_ celcius : Bool) -> Int {
        let i = Int(self)
        let c = i - 273
        if celcius{
            return c
        }else{
            let f = c * 9 / 5 + 32
            return f
        }
        
        
        
        
    }
    
    
}



extension UIView{
    
    ///// set background image according to weather
    func drawImage(imgName: String){
        
        guard let imageView = UIImage(named: imgName) else{
            return
        }
        UIGraphicsBeginImageContext(self.frame.size)
        imageView.draw(in: self.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor(patternImage: image!)
        

    }
    
    
    func changeViewColor(darkBackground: Bool, tag: Int){
        if darkBackground{
            for i in 0...self.subviews.count-1{
                
                if self.subviews[i] is UILabel{
                    var label = UILabel()
                    label = self.subviews[i] as! UILabel
                    label.textColor = .white
                }
                if self.subviews[i] is UIImageView{
                    if tag == 1 {
                        
                    }else{
                        var imageview = UIImageView()
                        imageview = self.subviews[i] as! UIImageView
                      
                        
                        
                        imageview.image = imageview.image!.withRenderingMode(.alwaysTemplate)
                        imageview.tintColor = .white
                        
                    }
                }
            }
        }else{
            for i in 0...self.subviews.count-1{
                
                if self.subviews[i] is UILabel{
                    var label = UILabel()
                    label = self.subviews[i] as! UILabel
                    label.textColor = .black
                }
                
                if self.subviews[i] is UIImageView{
                    if tag != 1{
                        var image = UIImageView()
                        image = self.subviews[i] as! UIImageView
                   
                        
                        image.image = image.image!.withRenderingMode(.alwaysTemplate)
                        image.tintColor = .black
                    }
                }
            }
            
            
        }
        
        
    }

    
    
    

    
    
}


extension UIViewController{
    
    
    
    func changeNavColors(darkBG: Bool){
        if darkBG{
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            self.navigationItem.leftBarButtonItem?.tintColor = .white
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            self.navigationController?.navigationBar.tintColor = .white
          
        }else{
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
            self.navigationItem.leftBarButtonItem?.tintColor = .black
            self.navigationItem.rightBarButtonItem?.tintColor = .black
            self.navigationController?.navigationBar.tintColor = .black
         
        }
        
        
    }

    
}
   


extension String{
    
    
    func getDateAndHour(date: Bool)->String{
        
        let dateArr = self.components(separatedBy: " ")
        let timeFromArr = dateArr[1]
        let dateFromArr = dateArr[0]
        if date{
            return dateFromArr
        }
        else{
            return timeFromArr
        }
        
    }
    
    func getIntFromString(seperator: String, values: Int)->[Int]?{
        
        let arr = self.components(separatedBy: seperator)
        var returnedArr : [Int] = []
        for i in 0...values-1{
            guard let value = Int(arr[i]) else{
                return nil
            }
            returnedArr.append(value)
        }
       
        return returnedArr
        
        
    }
    
    
    
    
    
    
}
