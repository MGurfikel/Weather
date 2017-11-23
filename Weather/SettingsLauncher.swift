//
//  SettingsLauncher.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/25/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class Setting : NSObject{
    
    var name : String
    let imgName : String
    
     init(name: String, imgName : String) {
        self.name = name
        self.imgName = imgName
    }
    
    
    
}


class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let sharedSettings = SettingsLauncher()
    let cellWidth : CGFloat = 250
    let cellHeight : CGFloat = 50
    var haveSetting : Bool = false

     let blackView = UIView()
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
        
        
    }()
    
    let cellId = "cell"
    var settingsArr : [Setting] = {
        
        return [Setting(name: "Find Me In GPS", imgName: "icons8-marker-3"), Setting(name: "Go To Favorite", imgName: "icons8-star"), Setting(name: "Change To °F" , imgName: "icons8-temperature")]
        
    }()
    
    var vc : ViewController?
    func showSettings(sender:UIBarButtonItem){
        collectionView.reloadData()
    if let window = UIApplication.shared.keyWindow{
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        window.addSubview(blackView)
        window.addSubview(collectionView)
        //let senderCGRect : CGRect = (sender.customView?.frame)!
       let view =  sender.value(forKey: "view") as? UIView
        let cgRect = view?.frame
       // print(view?.frame.origin.x ?? "no")
       // let x = (cgRect?.origin.x)!
      //let y = (cgRect?.origin.y)!
        let width : CGFloat = 200
        let x = window.frame.width - width
        let height : CGFloat = CGFloat(settingsArr.count) * cellHeight
       // let y = window.frame.height - height
        collectionView.frame = CGRect(x: window.frame.width, y: 0, width: width, height: height)
        
        blackView.frame = window.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.collectionView.frame = CGRect(x: x, y: 20, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
        
    
        
        
        
       }
        
    
        
    }
    
    
    func handleDismiss(setting : Setting){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.collectionView.frame = CGRect(x: window.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed : Bool) in
            if self.haveSetting{
           // if setting.name != "" {
            self.vc?.showController(setting: setting)
                self.haveSetting = false
            
           }
        }
        
        
        
        
    }
    
    
    
    override init() {
        super.init()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(settingCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    func refreshData(){
        
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! settingCell
     let setting = settingsArr[indexPath.row]
        if setting.name == "Change To °F" || setting.name == "Change To °c"{
            if AppManager.manager.lastId == nil{
                cell.isUserInteractionEnabled = false
            }else{
                cell.isUserInteractionEnabled = true
            }
            if !AppManager.manager.celcius{
                setting.name = "Change To °c"
            }else{
                setting.name = "Change To °F"
            }
        }
        
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  let setting = self.settingsArr[indexPath.row]
        haveSetting = true
        handleDismiss(setting: setting)
        
        

    }
    
    
    
    
    
    
    
    
    
    
    

}
