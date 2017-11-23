//
//  SearchTableViewController.swift
//  
//
//  Created by Moran Gurfinkel on 10/9/17.
//
//

import UIKit
import CoreData
import RESideMenu


class SearchTableViewController: UITableViewController, UISearchBarDelegate, RESideMenuDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    var filteredArray = [Location]()
    var favoriteArray : [FavoriteLocations] = []
    var addToFavorite : Bool = false
    var starClicked : Bool = false
    var searchControllerTableView : Bool = false
    var lastReasearch : [LastReasearch] = []
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    var controller : NSFetchedResultsController<Location>!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///////
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationController?.view.backgroundColor = .clear
     ////////////
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .white
        textFieldInsideSearchBar?.textColor = .black
        //////////////
        
        favoriteArray = DBManager.manager.fetchFavoriteLocations()
        
        lastReasearch = DBManager.manager.lastReasearch()
        //////////
        searchBar.delegate = self
        sideMenuViewController.delegate = self
        //////////
        refresh(using: nil)
        
   
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        guard let imageView = AppManager.manager.imageBackground else{
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "beachDay"))
            return
        }
          
        guard let image = UIImage(named: imageView) else{
            return
        }
        self.tableView.backgroundView = UIImageView(image: image)
        guard AppManager.manager.darkBackground != nil else{
            tableView.reloadData()//// do i need it. i want to return...
            return
        }
       self.changeNavColors(darkBG: AppManager.manager.darkBackground!)
    
    
        
        tableView.reloadData()
        
    }
    
  
    func refresh(using query: String?){
      
        self.controller = DBManager.manager.locationFetchedResultController(with: query)
        self.controller.delegate = self
      
        self.tableView.reloadData()
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)!{
      
        tableView.reloadData()
            
        }else{
            
       refresh(using: searchText)
     }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
 
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (searchBar.text?.isEmpty)!{
            lastReasearch = DBManager.manager.lastReasearch()
            return lastReasearch.count
        }else{
        return (controller.sections?[section].numberOfObjects)!
        }
    }

    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableCell
        ////////
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.selectedBackgroundView = bgColorView
        
        
        /////////
        
        var objId : Int32 = 0
        if (searchBar.text?.isEmpty)!{
            lastReasearch = DBManager.manager.lastReasearch()
            let obj = lastReasearch[indexPath.row]
            objId = obj.id
            cell.configureLastReaserch(with: obj)
            
        }else{
            let obj = controller.object(at: indexPath)
             objId = controller.object(at: indexPath).id
            cell.configure(with: obj)
        }
        
        //////////
        /////////check if the location is favorite
        
        favoriteArray = DBManager.manager.fetchFavoriteLocations()
         var image : UIImage
        if !favoriteArray.isEmpty{
            var counter : Int = 0
            
            for i in 0...favoriteArray.count-1{
                if favoriteArray[i].id == objId{
                   image = UIImage(named: "icons8-star_filled")!
                }else{
                    counter += 1
                  
                }
                
                
            }
            if counter == favoriteArray.count - 1{
             image = UIImage(named: "icons8-star_filled")!
            }
            else{
                image = UIImage(named: "icons8-star")!
            }
        }else{
         image = UIImage(named: "icons8-star")!
        }
        
        ///////////
        cell.imageView?.image = image
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.tag = indexPath.row
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.imageView?.addGestureRecognizer(tapRecognizer)
        ////////////
        //////change view color according to the background
       if let darkBG = AppManager.manager.darkBackground{
        
        cell.contentView.changeViewColor(darkBackground: darkBG, tag: 1)
        }
        //////////////////
       return cell
    
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let nav = self.sideMenuViewController.contentViewController as? UINavigationController
        let center = nav?.viewControllers.first as? ViewController
        if (searchBar.text?.isEmpty)!{
            let obj = lastReasearch[indexPath.row]
            center?.latitude = String(obj.latitude)
            center?.longitude = String(obj.longitude)
            
            center?.id = obj.id
        }else{
            let obj = controller.object(at: indexPath)
            center?.latitude = String(obj.latitude)
            center?.longitude = String(obj.longitude)
            center?.id = obj.id
            saveLastReaserch(with: obj)
        }
       
        searchBar.endEditing(true)
        center?.refreshButton.isEnabled = true
        self.sideMenuViewController.hideViewController()

    }
    
    
    func saveLastReaserch(with obj : Location){
         lastReasearch = DBManager.manager.lastReasearch()
        ///keep only 10 last searches
        if lastReasearch.count == 10{
            DBManager.manager.deletelastSearch(last: lastReasearch[9])
        }
        
        
         let last = LastReasearch(context: DBManager.manager.persistentContainer.viewContext)
        
       let timeInterval = Date().timeIntervalSince1970
        last.city = obj.city
        last.id = obj.id
        last.state = obj.state
        last.latitude = obj.latitude
        last.longitude = obj.longitude
        last.time = timeInterval
        
          DBManager.manager.saveContext()
        lastReasearch = DBManager.manager.lastReasearch()

    }
    
    
    
    func saveToFavorites(indexPath: IndexPath){
        var objId : Int32 = 0
        var city : String
        var state : String
        var longitude : Double
        var latitude : Double
        
        if (searchBar.text?.isEmpty)!{
            let obj = lastReasearch[indexPath.row]
            objId = obj.id
            city = obj.city!
            state = obj.state!
            latitude = obj.latitude
            longitude = obj.longitude
        }else{
           let obj = controller.object(at: indexPath)
            objId = obj.id
            city = obj.city!
            state = obj.state!
            latitude = obj.latitude
            longitude = obj.longitude
            
        }
        
       
        
        
        
        var counter : Int = 0
        var indexPath : Int?
        if !self.favoriteArray.isEmpty{
            for i in 0...self.favoriteArray.count-1{
                if self.favoriteArray[i].id == objId{
                    indexPath = i
                }
                else{
                    counter += 1
                }
                
            }
            if counter == favoriteArray.count-1{
                
                DBManager.manager.deleteFavorite(favorite: favoriteArray[indexPath!])
               
                
            }else{
                let timeInterval = Date().timeIntervalSince1970
                let favorite = FavoriteLocations(context: DBManager.manager.persistentContainer.viewContext)
                favorite.city = city
                favorite.state = state
                favorite.latitude = latitude
                favorite.longitude = longitude
                favorite.id = objId
                favorite.insertTime = timeInterval
                
            }
            
        }else{
            let timeInterval = Date().timeIntervalSince1970
            let favorite = FavoriteLocations(context: DBManager.manager.persistentContainer.viewContext)
            favorite.city = city
            favorite.state = state
            favorite.latitude = latitude
            favorite.longitude = longitude
            favorite.id = objId
            favorite.insertTime = timeInterval

            
            
        }
        DBManager.manager.saveContext()
        favoriteArray = DBManager.manager.fetchFavoriteLocations()
        tableView.reloadData()
        
         }
    
    
    func imageTapped(recognizer: UITapGestureRecognizer) {
              
        let index = recognizer.view?.tag
        let indexPath = IndexPath(row: index!, section: 0)
       saveToFavorites(indexPath: indexPath)
       
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        let nav = self.sideMenuViewController.contentViewController as? UINavigationController
        let center = nav?.viewControllers.first as? ViewController
       center?.showWeather()
    }

    
    


  


}











extension SearchTableViewController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type{
        case .insert:
            let index = IndexSet(integer: sectionIndex)
            tableView.insertSections(index, with: .automatic)
            
            
        case .delete:
            let index = IndexSet(integer: sectionIndex)
            tableView.deleteSections(index, with: .automatic)
            
            
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        case .update:
            guard let cell = tableView.cellForRow(at: indexPath!) as? SearchTableCell,
                let location = anObject as? Location else{
                    return
            }
        cell.configure(with: location)
            
            
        case .move:
            
            guard let cell = tableView.cellForRow(at: indexPath!) as? SearchTableCell,
                let location = anObject as? Location else{
                    return
            }
            cell.configure(with: location)
            
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
          
          
            cell.configure(with: location)
        }
        
        
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       tableView.endUpdates()
    }

    
    
    
    
    
    
    
}


extension UIView{
    
    
    var selectedRowColor : UIView{
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return bgColorView
    }
    
    
    
    
    
}

