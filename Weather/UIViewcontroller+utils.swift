//
//  UIViewcontroller+utils.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/9/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//


import UIKit
import RESideMenu

extension UIViewController{
    
    @IBAction func showMenu(){
        
        if GeneralData.data.isLTR{
            self.sideMenuViewController.presentLeftMenuViewController()
            
        }else{
            self.sideMenuViewController.presentRightMenuViewController()
        }
        
        
    }
    
    
    
}
