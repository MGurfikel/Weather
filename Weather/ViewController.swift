import UIKit
import MapKit
import CoreLocation
import Alamofire
import APTimeZones
import SwiftSpinner

protocol ViewControllerDelegate {
    func loadedData(loaded : Bool)
    
    
}



class ViewController: UIViewController, CLLocationManagerDelegate, favoriteDelegate, extendedVCDelegate{

   
   
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weekForecastTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
     @IBOutlet weak var firstCell: FirstCellView!
    @IBOutlet weak var moreDetailsCellView: moreDetailsView!
    
    @IBOutlet weak var addToFavoriteItem: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var extendedForecastDict : [[DetailedCity]] = []
    var extendedForecastArray : [DetailedCity] = []
    
    var weekCityArray : [weekCity] = []
    var locationArr : [Location]!
    var collectionArray: [DetailedCity] = []
    var latitude: String?
    var longitude: String?
    var state : String?
    var city : String?
    var id : Int32?
    var gpsClicked : Bool = false
    var firstLoaded : Bool = true
    var launched : Bool = false
    
    let button = UIButton.init(type: .custom)
    
    var delegate : ViewControllerDelegate? = nil

    var firstCity : Bool = true
    var btn = UIButton(){
        didSet{
            refreshButton.tintColor = AppManager.manager.darkBackground! ? .white : .black
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /////
        viewNoData.isHidden = true
        viewNoData.drawImage(imgName: "beachDay")
        ///////
        SwiftSpinner.setTitleFont(UIFont(name: "Avenir Next", size: 22.0))
        SwiftSpinner.show("Connecting...")
        //////
       refresh()
        //////
        //DBManager.manager.deleteRecords()
        //////
       
        if !GeneralData.data.firstLoad{//firstLoad is false first time - until first location is shown
            button.isHidden = true
        }
       
      
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.view.backgroundColor = .clear
        self.navigationController?.view.backgroundColor = .clear
      
        //////////
        button.setImage(UIImage.init(named: "icons8-star"), for: UIControlState.normal)
       button.addTarget(self, action:#selector(updateFavorite), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems?[1] = barButton
         //////
        let origImage = UIImage(named: "icons8-refresh")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        refreshButton.setImage(tintedImage, for: .normal)
        ////////////
         NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .locationFound, object: nil)
         ///////////
        getLastLocation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.id == nil{
            print("no id")
            viewNoData.isHidden = false
            SwiftSpinner.show(duration: 5.0 ,title: "Welcome! Search for new location, or use the GPS").addTapHandler({
                SwiftSpinner.hide()
            })
            
            
            
        }else{
            print("id")
            if !launched{
            showWeather()
            }
        }
        

        refreshButton.isEnabled = false
        
    }

        func getLastLocation(){
            let classId = UserDefaults.standard.object(forKey: "id")
          guard classId != nil else{
                AppManager.manager.celcius = true
                print("id is nil")
                return
                
            }
            print("id is not nil")
            
            latitude = UserDefaults.standard.string(forKey: "latitude")
            longitude = UserDefaults.standard.string(forKey: "longitude")
            id = Int32(UserDefaults.standard.integer(forKey: "id"))
            AppManager.manager.celcius = UserDefaults.standard.bool(forKey: "celcius")
            
          

    }

  
    
    
    func handleNotification(_ note : Notification){
        guard gpsClicked else{
            return
        }
        gpsClicked = false
        guard let gpsLocation = AppManager.manager.location else{
            let alert = AppManager.manager.createAlert(title: "GPS Error", message: "Can't Find Location")
              self.present(alert, animated: true, completion: nil)
            return
        }
        latitude = String(gpsLocation.coordinate.latitude)
        longitude = String(gpsLocation.coordinate.longitude)
        showWeather()

    }
    
    func findWithGPS(){
        AppManager.manager.startLocation()
        if AppManager.manager.errorGPS != nil, AppManager.manager.errorGPS == true {
            AppManager.manager.errorGPS = false
            let alert = AppManager.manager.createAlert(title: "GPS Error", message: "No GPS Connection")
          self.present(alert, animated: true, completion: nil)
            
        }
}
    
//////////////////////////////////////////////////////////
    //setting Launcher 
    
      lazy var settingLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.vc = self
        return launcher
        
    }()
   
    @IBAction func navMoreAction(_ sender: UIBarButtonItem) {
       
      settingLauncher.showSettings(sender: sender)
        
        
    }
    func showController(setting : Setting){
        switch setting.name{
        case "Go To Favorite":
            let favoriteArray = DBManager.manager.fetchFavoriteLocations()
            if favoriteArray.count == 0{
                let alert = AppManager.manager.createAlert(title: "", message: "Favorite Locations Is Empty")
                self.present(alert, animated: true, completion: nil)
                return
                
            }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let favVC = storyBoard.instantiateViewController(withIdentifier: "favorite") as! FavoriteLocationsViewController
        favVC.delegate = self
        if self.id != nil{
            favVC.locationExists = true
            
        }else{
            favVC.locationExists = false
        }
      navigationController?.pushViewController(favVC, animated: true)
            case "Change To °F", "Change To °c":
                AppManager.manager.celcius = AppManager.manager.celcius ? false : true
            showWeather()
            case "Find Me In GPS":
              gpsClicked = true
            findWithGPS()
        default:
            return
            
       
        
        }
    }
    ////////////////////////////////////
    @IBAction func refreshDataButton(_ sender: UIButton) {
        sender.isEnabled = false
        sender.isHidden = true
        indicator.startAnimating()
        showWeather()
        indicator.stopAnimating()
        sender.isHidden = false
        sender.isEnabled = true
    }
    
    //////////////////
    ///change the star bar button item according to favoriteLocations
    
    func changeItem(id: Int32?, favorite : Bool?){
        print(id ?? "no id")
        if favorite != nil{
        if favorite!{
            
            button.setImage(UIImage.init(named: "icons8-star_filled"), for: UIControlState.normal)
        }else{
            button.setImage(UIImage.init(named: "icons8-star"), for: UIControlState.normal)
        }
            return
        }
        
        
        //// if favorite is nil - need to check whether it is favorite or not
        guard id != nil else{
            return
        }
         let favoriteArray : [FavoriteLocations] = DBManager.manager.fetchFavoriteLocations()
      
        if !favoriteArray.isEmpty{
           
            var counter : Int = 0
        for i in 0...favoriteArray.count-1{
        if !(favoriteArray[i].id == id){
      
          counter += 1
            }
            }
            if counter == favoriteArray.count - 1{
                button.setImage(UIImage.init(named: "icons8-star_filled"), for: UIControlState.normal)
                return
            }
        }
            /// if favoriteArray is empty || the location whom pressed wasn't favorite
            button.setImage(UIImage.init(named: "icons8-star"), for: UIControlState.normal)
        
    }
    
    /////////////
    func updateFavorite(){
        
        guard self.id != nil else{
            return
        }
        let favorite : [FavoriteLocations] = DBManager.manager.fetchFavoriteLocations()
        
        if !favorite.isEmpty{
            var counter : Int = 0
            var index : Int?
            
            for i in 0...favorite.count-1{
                if favorite[i].id == self.id{
                    index = i
                }else{
                    counter += 1
                }
                
            }
            if counter == favorite.count - 1{
                /// the location is already in favorites - delete it from favorite
                
                DBManager.manager.deleteFavorite(favorite: favorite[index!])
                
                changeItem(id : self.id, favorite: false)
                return
            
               }
        }
        
        ///// if it is not favorite or favorite array is empty - add location to favorite
            let newFavorite = FavoriteLocations(context: DBManager.manager.persistentContainer.viewContext)
            newFavorite.city = city
            newFavorite.state = state
            let lat  = Double(latitude!)
            let lon = Double(longitude!)
           newFavorite.latitude = lat!
            newFavorite.longitude = lon!
            newFavorite.id = id!
        let timeInterval = Date().timeIntervalSince1970
        newFavorite.insertTime = timeInterval
            DBManager.manager.saveContext()
            changeItem(id: nil, favorite: true)
        
    }
    
    
    ////////
  
    func refresh(){
        extendedForecastDict = []
        extendedForecastArray = []
        weekCityArray = []
        collectionArray = []
       
        self.collectionView.reloadData()
        self.weekForecastTableView.reloadData()
        
        
        
    }
    
  
    ////////////
    
    func setNavColors(){
        guard AppManager.manager.darkBackground != nil else{
            return
        }
     self.changeNavColors(darkBG: AppManager.manager.darkBackground!)
     self.btn = self.refreshButton
    
    
    }

///////////

    func showWeather(){
        
   
        guard self.latitude != nil, self.longitude != nil else{
            return
        }
        refresh()
        AppManager.manager.getTimeZone(lat: latitude!, lon: longitude!)// to refresh timezoneutils? how?
        
           /////request for current weather
        APIManager.shared.getCity(lat: latitude!, lon: longitude!) {
            
            if let str = $1?.localizedDescription{
                let alert = AppManager.manager.createAlert(title: "Error", message: str)
                self.present(alert, animated: true, completion: nil)
                SwiftSpinner.hide()
                print(str)
                return
            }
            guard !$0.isEmpty else{
                print("no location found 1")
                if GeneralData.data.firstLoad{
                    self.getLastLocation()
                    self.showWeather()
                }
                    SwiftSpinner.hide()
                let alert = AppManager.manager.createAlert(title: "Error", message: "Can't Find Location")
                self.present(alert, animated: true, completion: nil)
                

                return
            }
             let location = $0[0]
                let city = location.city
                self.navigationItem.title = city ?? ""
                self.state = location.country
                self.city = city
                self.id = location.id
            
             AppManager.manager.lastId = self.id
            AppManager.manager.lastLongitude = self.longitude
            AppManager.manager.lastLatitude = self.latitude
         
             
          
            ///////////
            /////make view
            let imgStr = AppManager.manager.getBackgroundImage(desc: location.description, day: location.day)
            self.view.drawImage(imgName: imgStr)
            AppManager.manager.imageBackground = imgStr
            self.setNavColors()
            self.changeItem(id: self.id, favorite: nil)
            self.firstCell.configure(with: location)
            self.moreDetailsCellView.configure(with: location)
            self.showWeather2()// second request to api
           ///////////////
         
        }
        
        //////
    }
    
    func showWeather2(){
        //// request for week forcast
            APIManager.shared.getFiveDayForecast(lat: latitude!, lon: longitude!) {
               
                if let str = $1?.localizedDescription{
                   let alert = AppManager.manager.createAlert(title: "Interenet Error", message: "No Interent Connection")
                     self.present(alert, animated: true, completion: nil)
                    print(str)
                     SwiftSpinner.hide()
                    return
                }
                
                guard !$0.isEmpty else{
                    print("no location found 2")
                    if GeneralData.data.firstLoad{
                        self.getLastLocation()
                        self.showWeather()
                    }
                        SwiftSpinner.hide()
                   
                    let alert = AppManager.manager.createAlert(title: "Error", message: "Can't Find Location")
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    return
                }

           /////
                
                ////set the details of the collection view - collectionArray (array of detailedCity) contains the next day weather - every three hours. (8 values).
              
                self.setCollectionView(detCity : $0)
               
              ////////
                
                ///set the details of the table array - shows week forecast. (4 days).
                
                self.setTableView(detCity: $0)
                
                
                /////////////
                self.weekForecastTableView.reloadData()
               self.refreshButton.isEnabled = true
                
          ////////////
                //save temporary last location
                 self.temporaryLastLocation()
                //scroll view to top
                let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                self.scrollView.setContentOffset(desiredOffset, animated: true)
                
                if !self.launched{
                    SwiftSpinner.show(duration: 3.0, title: "Connecting...")
                    self.launched = true
                }
                if !GeneralData.data.firstLoad{
                    GeneralData.data.firstLoad = true
                    self.viewNoData.isHidden = true
                    self.button.isHidden = false
                }
            }
       
    }
    
    
       func temporaryLastLocation(){
        let defults = UserDefaults.standard
        defults.set(self.longitude!, forKey: "longitude")
        defults.set(self.latitude!, forKey: "latitude")
        defults.set(self.id, forKey: "id")
        defults.set(AppManager.manager.celcius, forKey: "celcius")
        defults.synchronize()
    }
    
    
    
    
    func setCollectionView(detCity : [DetailedCity]){
        
        //avoid bug
        if self.collectionArray.count == 10{
            self.collectionArray = []
        }
        for i in 0...9{
            
            self.collectionArray.append(detCity[i])
        }
        
        self.collectionView.reloadData()
        
    }
    

    
    func setTableView(detCity : [DetailedCity]){

        guard let timezone = AppManager.manager.timeZoneUtils else{
            return
        }
        var countForDays : Int = 0
        //check when the next day after current starts (what value in the array) (get in the api the rest of current day + next 4 days)
        let collection : [DetailedCity] = detCity
       ////
        
        let currentDate = AppManager.manager.getCurrentTime(date: nil, timeZone: timezone, dateBool: true)//deal with the !
        var weekdayInt : Int?
        let city = collection[0]
        guard city.date != nil else{
            return
        }
        for i in 0...collection.count-1{
            let date = collection[i].date
            if currentDate != date{
                countForDays = i
                weekdayInt = collection[i].weekdayInt
                break
                
            }
        }
        guard weekdayInt != nil else{
            return
        }
      
        var switchingDate = city.date
        var countDaysInForecast : Int = 0
        for i in 0...collection.count - 1 {
             if switchingDate != collection[i].date{
                switchingDate = collection[i].date
                countDaysInForecast += 1
            }
           
            }
            tableViewHeight.constant = 44 * CGFloat(countDaysInForecast)
        
        if weekdayInt == 8{
            weekdayInt = 1
        }
        ////
       
        
        /////
        var countTillEnd : Int = countForDays
        var backupArray : [String] = []
        var descArray : [String] = []
        var fromDay : Int = countForDays
        var highTemp : Int = 0
        var lowTemp : Int = 0
        var dailyDate : String!
        var date = collection[countForDays].date
        //////
        for _ in 0...countDaysInForecast - 1{
            for i in fromDay...collection.count-1{
                let dCity = collection[i]
                guard dCity.date != nil, dCity.temp != nil else{
                    return
                }
                
                
                
                if date == dCity.date{
                    guard let currentTemp = Int(dCity.temp!) else{
                        return
                    }
                    if i==fromDay{
                        highTemp = currentTemp
                        lowTemp = currentTemp
                    }
                    if currentTemp>highTemp, i>fromDay{
                        highTemp = currentTemp
                    }
                    if currentTemp<lowTemp, i>fromDay{
                        lowTemp = currentTemp
                    }
                
                }else{
                    fromDay = i
                    date = collection[i].date
                    break
                    
                }
              countTillEnd += 1
                if collection[i].desc != nil, collection[i].day != nil{
                if collection[i].day!{
                    //add description of weather in day time to array of desc -> choose the desc who found the most.
                descArray.append(detCity[i].desc!)
                }else{
                    backupArray.append(collection[i].desc!)
                    
                    }
                }
                dailyDate = collection[i].date!
                self.extendedForecastArray.append(detCity[i])
                
            }
            
            //array of dictionaries of detailedCity. cotains the whole detailed weather data for the next 4 days.
            self.extendedForecastDict.append(self.extendedForecastArray)
            
            self.extendedForecastArray = []
            var descForImg : String
            if descArray.count != 0{
                descForImg = self.chooseDescription(array: descArray)
            }
            else if backupArray.count != 0 && descArray.count == 0{
            descForImg = self.chooseDescription(array: backupArray)
            }else if backupArray.count != 0 && descArray.count != 0{
                
                backupArray.append(contentsOf: descArray)
                descForImg = self.chooseDescription(array: backupArray)
            }else{
                descForImg = ""
            }
        
        
            descArray = []
            backupArray = []
            //////
            let weekday = AppManager.Weekday(rawValue: weekdayInt!)?.name ?? "no day"
            ///dictionary of table array of table view in main VC - table view of 4 days summsrized forecast.
            let dict : [String : Any] = ["maxTemp" : highTemp, "minTemp" : lowTemp, "weekday" : weekday, "description" : descForImg, "date": dailyDate]
            highTemp = 0
            lowTemp = 0
            weekdayInt! += 1
            if weekdayInt == 8{
                weekdayInt = 1
            }
            //avoid bug
            if self.weekCityArray.count == countDaysInForecast {
                self.weekCityArray = []
            }
            //// weekCityArray - array of weekCity - contains all next four days forecast
            self.weekCityArray.append(weekCity(dict)!)
            
            //avoid bug
            if countTillEnd == collection.count - 1{
                break
            }
           
           
        }
        
    self.weekForecastTableView.reloadData()
        
    }
    
    
    //check which description is most common
    func chooseDescription(array: [String]) -> String{
        var rightDesc : String! // = ""
        var descDict : [String:Int] = [:]
        var valuesArr : [String] = []
        var descCounter : Int = 0
        var add : Bool = true
        let array = array
        for i in 0...array.count-1{
            let firstDesc = array[i]
            if descDict[firstDesc] != nil{
                add = false
            }
            for i in 0...array.count-1{
                if add{
                let secondDesc = array[i]
                if firstDesc == secondDesc{
                    descCounter += 1
                }
            }
            }
            if add{
           valuesArr.append(firstDesc)
            descDict[firstDesc] = descCounter
            descCounter = 0
            }
            add = true
            
        }

        var counter : Int = 0
        var most : Int = 1
        for i in 0...descDict.count-1{
            if most < descDict[valuesArr[i]]!{
                most = descDict[valuesArr[i]]!
                rightDesc = valuesArr[i]
             
            }else{
                if counter == i{
                counter += 1
                }
            }
            
        }
        if counter == descDict.count{
            
            rightDesc = array[0]
        }
        print(counter)
    
       return rightDesc
        
        
        
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let nextVC = segue.destination as? ExtendedViewController,
            let indexpath = weekForecastTableView.indexPathForSelectedRow {// show in ExtendedViewController the relevant data - the weather of day whom pressed in the table view
            nextVC.detailedCityArray = self.extendedForecastDict[indexpath.row]
            nextVC.delegate = self
        }
           }
    
    func getCoordFromFavorite(lon: String, lat: String, id: Int32) {
   
        self.latitude = lat
        self.longitude = lon
        self.id = id
       showWeather()
    }
    
    func refreshDelegate() {
        showWeather()
    }




}




extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return collectionArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCell
      let obj = collectionArray[indexPath.row]
        cell.configure(with: obj)
        
        if let darkBG = AppManager.manager.darkBackground{
        cell.contentView.changeViewColor(darkBackground: darkBG, tag: 0)
        }
        return cell
    }
    
   
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return weekCityArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeekForecastCell
      ///////
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.selectedBackgroundView = bgColorView

        
        /////////
        let obj = weekCityArray[indexPath.row]
        cell.configure(with: obj)
     //////
        if let darkBG = AppManager.manager.darkBackground{
            cell.contentView.changeViewColor(darkBackground: darkBG, tag: 0)
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}


