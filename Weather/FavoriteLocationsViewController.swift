//
//  FavoriteLocationsViewController.swift
//  
//
//  Created by Moran Gurfinkel on 10/12/17.
//
//

import UIKit
import CoreData
import MapKit


protocol favoriteDelegate{
    func getCoordFromFavorite(lon: String, lat: String, id: Int32)
}


class FavoriteLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
   
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var delegate : favoriteDelegate? = nil
    var controller : NSFetchedResultsController<FavoriteLocations>!
    var longitude : String?
    var latitude : String?
    var id : Int32?
    var locationExists : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor?.withAlphaComponent(0.5)
        
        /////////
        self.controller = DBManager.manager.favoriteLocationFetchedResultController()
        self.controller.delegate = self 
       /////////
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FavoriteLocationsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        //////////
         favoriteTableView.backgroundColor = .clear
   
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let imageFromManager = AppManager.manager.imageBackground else{
           self.view.drawImage(imgName: "beachDay")
            
            return
        }
        
        
        
       
      self.view.drawImage(imgName: imageFromManager)
        
        ///////////
        
        guard AppManager.manager.darkBackground != nil else{
            return
        }
        self.changeNavColors(darkBG: AppManager.manager.darkBackground!)
        
        
        
    }
  
    func refresh(){
        self.controller = DBManager.manager.favoriteLocationFetchedResultController()
        self.controller.delegate = self
        favoriteTableView.reloadData()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
      return (controller.sections?[section].numberOfObjects)!
    
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteLocationCell
        ///////
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.selectedBackgroundView = bgColorView
        /////
        let obj = controller.object(at: indexPath)
        cell.configure(with: obj)
        /////
        if let darkBG = AppManager.manager.darkBackground{
            cell.contentView.changeViewColor(darkBackground: darkBG, tag: 0)
        }
       
        
        return cell
    }
    
    
    
    
    
    
  func back(sender : UIBarButtonItem){
    if delegate != nil, locationExists! {
        latitude = AppManager.manager.lastLatitude
        longitude = AppManager.manager.lastLongitude
        id = AppManager.manager.lastId
        delegate?.getCoordFromFavorite(lon: longitude!, lat: latitude!, id: id!)
        }
    
    
    navigationController?.popViewController(animated: true)
    dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            let obj = controller.object(at: indexPath)
            latitude = String(obj.latitude)
            longitude = String(obj.longitude)
            id = obj.id
            delegate?.getCoordFromFavorite(lon: longitude!, lat: latitude!, id: id!)
            
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        
        }
   
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.delete {
              let obj = controller.object(at: indexPath)
                DBManager.manager.context.delete(obj)
                DBManager.manager.saveContext()
                refresh()
              
            }
        }
        
    
    
    
    
    
        
  
}




extension FavoriteLocationsViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.beginUpdates()
    }
    
    
   /* func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type{
        case .insert:
            let index = IndexSet(integer: sectionIndex)
            favoriteTableView.insertSections(index, with: .automatic)
            
            
        case .delete:
            let index = IndexSet(integer: sectionIndex)
            favoriteTableView.deleteSections(index, with: .automatic)
            
            
        default:
            break
            }
        }*/
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            favoriteTableView.insertRows(at: [newIndexPath!], with: .automatic)
            
        case .delete:
            favoriteTableView.deleteRows(at: [indexPath!], with: .automatic)
            
        case .update:
            guard let cell = favoriteTableView.cellForRow(at: indexPath!) as? FavoriteLocationCell,
                let location = anObject as? FavoriteLocations else{
                    return
            }
            cell.configure(with: location)
            
            
        case .move:
            
            guard let cell = favoriteTableView.cellForRow(at: indexPath!) as? FavoriteLocationCell,
                let location = anObject as? FavoriteLocations else{
                    return
            }
            cell.configure(with: location)
            favoriteTableView.moveRow(at: indexPath!, to: newIndexPath!)
            
            
            }
       
        
            
            
        }
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.endUpdates()
        
    }
}
