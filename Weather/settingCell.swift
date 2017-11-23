//
//  settingCell.swift
//  Weather
//
//  Created by Moran Gurfinkel on 10/25/17.
//  Copyright © 2017 Moran Gurfinkel. All rights reserved.
//

import UIKit

class settingCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.black : UIColor.white
            
            cellLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            cellIcon.tintColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    
    var setting:Setting? {
        didSet{
            cellLabel.text = setting?.name
            
            if let imageName = setting?.imgName{
                
                cellIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                cellIcon.tintColor = .black
            }
            
        }
    }
    
    let cellLabel : UILabel = {
        let width : CGFloat = SettingsLauncher.sharedSettings.cellWidth
        let height : CGFloat = SettingsLauncher.sharedSettings.cellHeight
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 17)
       
        
        return label
    }()
    
    let cellIcon : UIImageView = {
        let width : CGFloat = SettingsLauncher.sharedSettings.cellWidth
        let height : CGFloat = SettingsLauncher.sharedSettings.cellHeight
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
        
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    func setUpView(){
        
       addSubview(cellLabel)
        addSubview(cellIcon)
  
       addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: cellIcon, cellLabel)
         addConstraintsWithFormat(format: "V:|[v0]|", views: cellLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: cellIcon)
        
        addConstraint(NSLayoutConstraint(item: cellIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    
    
    
}



extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
            
        }
    
    
    
}






