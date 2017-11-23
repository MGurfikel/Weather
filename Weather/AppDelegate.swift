//
//  AppDelegate.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/3/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit
import RESideMenu
import CoreData
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
      DBHelper.loadCities()
        
        let center = window?.rootViewController
        let menu = center?.storyboard?.instantiateViewController(withIdentifier: "right")
        let left = GeneralData.data.isLTR ? menu : nil
        let right = GeneralData.data.isLTR ? nil : menu
        let root = RESideMenu(contentViewController: center, leftMenuViewController: left, rightMenuViewController: right)
        
        ////
        
       /* let center = window?.rootViewController
        let menu = center?.storyboard?.instantiateViewController(withIdentifier: "right")
        let left =  menu
        
        let root = RESideMenu(contentViewController: center, leftMenuViewController: left, rightMenuViewController: nil)*/
        
        
        window?.rootViewController = root

        return true
    }

     func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
          DBManager.manager.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
          DBManager.manager.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
          DBManager.manager.saveContext()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
          DBManager.manager.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        
     
       DBManager.manager.saveContext()
    }

  

}

