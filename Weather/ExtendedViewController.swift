//
//  ExtendedViewController.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/9/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

protocol extendedVCDelegate{
    func refreshDelegate()
}

class ExtendedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var detailedCityArray : [DetailedCity]?
    var delegate : extendedVCDelegate? = nil
    

    @IBOutlet weak var bottomLayoutOutlet: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let darkBG = AppManager.manager.darkBackground{
         self.changeNavColors(darkBG: darkBG)
        }
        
        if let imageFromManager = AppManager.manager.imageBackground {
            
             self.view.drawImage(imgName: imageFromManager)
          
        }else{
            self.view.drawImage(imgName: "beachDay")
        }
     
        
        guard detailedCityArray != nil else{
            return
        }
        tableViewHeight.constant = 80 * CGFloat((detailedCityArray?.count)!)

        self.navigationItem.title = detailedCityArray![0].date

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if delegate != nil{
            delegate?.refreshDelegate()
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return detailedCityArray!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExtendedForecastCell
      
        //////
        let obj = detailedCityArray?[indexPath.row]
        cell.configure(with: obj!)
        /////
        if let darkBG = AppManager.manager.darkBackground{
         cell.contentView.changeViewColor(darkBackground: darkBG, tag: 0)
        }
        return cell
        
    }
   
 

}
