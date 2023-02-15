//
//  ViewController.swift
//  Weather App Attempt 2
//
//  Created by Kasra Panahi on 3/29/22.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation
import Kingfisher

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var describeWeather: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var temp4: UILabel!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var temp5: UILabel!
    @IBOutlet weak var image5: UIImageView!
    
    let apiKey = "[API-KEY]"
    
    var geoLocation = "london"
    
    var cityArray = [Cities]()
    
    var weatherArray = [Weather]()
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    var currentLocationWeatherExecution = false
    
    
    var tableData: [String] = []
    
    let cellReuseIdentifier = "cell"
    
    var currentLat: Double = 0.0
    var currentLon: Double = 0.0
    
    var farenheitTemp: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = search
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        
        requestCities()
    }
    
    
    func populate(x: Int) {
        self.tableData = []
        
        for index in 0 ... self.cityArray.count - 1 {
            
            var input: String
            
            if self.cityArray[index].capital.isEmpty == true {
                input = self.cityArray[index].city
                self.tableData.append(input)
                
            } else if self.cityArray[index].capital.isEmpty == false {
                input = self.cityArray[index].capital
                self.tableData.append(input)
            }
        }
        
        
        //https://stackoverflow.com/questions/26277371/swift-uitableview-reloaddata-in-a-closure
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0...self.cityArray.count - 1 {
            if tableData[indexPath.row] == self.cityArray[index].capital || tableData[indexPath.row] == self.cityArray[index].city {
                requestAll(location: tableData[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = self.tableData[indexPath.row]
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text != "" {
            self.tableData = []
            
            for index in 0...self.cityArray.count - 1 {
                if self.cityArray[index].capital.hasPrefix(text) {
                    self.tableData.append(self.cityArray[index].capital)
                }
            }
            self.tableData = self.tableData.sorted()
            self.tableView.reloadData()
        } else {
            self.populate(x: 5)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLat = locValue.latitude
        currentLon = locValue.longitude
        
        if self.currentLocationWeatherExecution == false {
            requestWeather(location: "Your Location", lat: locValue.latitude, lon: locValue.longitude)
            self.currentLocationWeatherExecution = true
        }
        
    }
    
    func requestAll(location: String) {
        print(location)
        
        //https://stackoverflow.com/questions/48179426/how-to-replace-spaces-in-string-with-underscore
        let correctLocation = location.replacingOccurrences(of: " ", with: "_")
        
        let url = URL(string: "https://nominatim.openstreetmap.org/search?q=\(correctLocation)&format=json")!
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error); return }
            let jsony = JSON(data!)
            let newerData = jsony.arrayValue
            
            let lat1 = newerData[0]["lat"].doubleValue
            let lon1 = newerData[0]["lon"].doubleValue
            
            self.requestWeather(location: location, lat: lat1, lon: lon1)
        }
        task.resume()
    }
    
    
    func requestWeather(location: String, lat: Double, lon: Double) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(self.apiKey)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error); return }
            //            self.weatherArray.removeAll()
            let jsony = JSON(data!)
            
            let describeWeather = jsony["weather"][0]["description"]
            let weatherType = jsony["weather"][0]["main"]
            
            let icon = jsony["weather"][0]["icon"]
            let iconURL = "http://openweathermap.org/img/w/\(icon).png"
            
            let temperature = jsony["main"]["temp"]
            
            print(type(of: temperature))
            let humidity = jsony["main"]["humidity"]
            
            print(location, describeWeather, weatherType, icon, iconURL, temperature, humidity)
            
            let fiveURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(self.apiKey)")!
            let tasker = URLSession.shared.dataTask(with: fiveURL) { (dataNew, responseNew, errorNew) in
                if let errorNew = errorNew {print(errorNew); return }
                
                let jsonNew = JSON(dataNew!)
                let dataArrayed = jsonNew["list"].arrayValue
                
                var newDataArray: [JSON] = []
                
                newDataArray.append(dataArrayed[0])
                
                for i in 0 ... dataArrayed.count - 1 {
                    
                    var y: String = ""
                    var x: String = ""
                    
                    if i < dataArrayed.count - 1 {
                        y = dataArrayed[i]["dt_txt"].stringValue
                        x = dataArrayed[i+1]["dt_txt"].stringValue
                        if let dotRange = x.range(of: " ") {
                            x.removeSubrange(dotRange.lowerBound..<x.endIndex)
                        }
                        
                        if y.contains(x) {
                            print(x, y)
                            
                        } else {
                            newDataArray.append(dataArrayed[i+1])
                            print(x)
                        }
                    }
                }
                print(type(of: newDataArray))
                
                self.populateData(location: "\(location)", describeWeather: "\(describeWeather)", weatherType: "\(weatherType)", icon: "\(icon)", iconURL: iconURL, temperature: "\(temperature)", humidity: "\(humidity)", dataArray: newDataArray)
                
            }
            tasker.resume()
        }
        task.resume()
    }
    
    func populateData(location: String, describeWeather: String, weatherType: String, icon: String, iconURL: String, temperature: String, humidity: String, dataArray: Array<JSON>) {
        print(location, describeWeather, weatherType, icon, iconURL, temperature, humidity)
        DispatchQueue.main.async {
            self.city.text = location
            self.describeWeather.text = describeWeather.capitalized
            
            if let myNumber = NumberFormatter().number(from: temperature) {
                let myInt = myNumber.intValue
                
                self.farenheitTemp = myInt
                
                let farenheit = "\(myInt)\u{00B0}F"
                //                let celsisus = "\((myInt-32)*5/9)\u{00B0}C"
                
                //                let both = "\(farenheit) or \(celsisus)"
                
                self.temperature.text = farenheit
            } else {
                print("error temperature is a string")
            }
            
            self.humidity.text = "Humidity: \(humidity)%"
            
            let trueIconURL = URL(string: iconURL)
            
            //https://stackoverflow.com/a/27517280
            //https://developer.apple.com/news/?id=jxky8h89
            self.imageView.kf.setImage(with: trueIconURL)
            
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
            print(dateFormatter.string(from: Date()))
            
            var weekDays: [String] = []
            
            weekDays.append(dateFormatter.string(from: Date()))
            
            if dateFormatter.string(from: Date()) == "Mon" {
                weekDays.append("Tue")
                weekDays.append("Wed")
                weekDays.append("Thu")
                weekDays.append("Fri")
            } else if dateFormatter.string(from: Date()) == "Tue" {
                weekDays.append("Wed")
                weekDays.append("Thu")
                weekDays.append("Fri")
                weekDays.append("Sat")
            } else if dateFormatter.string(from: Date()) == "Wed" {
                weekDays.append("Thu")
                weekDays.append("Fri")
                weekDays.append("Sat")
                weekDays.append("Sun")
            } else if dateFormatter.string(from: Date()) == "Thu" {
                weekDays.append("Fri")
                weekDays.append("Sat")
                weekDays.append("Sun")
                weekDays.append("Mon")
            } else if dateFormatter.string(from: Date()) == "Fri" {
                weekDays.append("Sat")
                weekDays.append("Sun")
                weekDays.append("Mon")
                weekDays.append("Tue")
            } else if dateFormatter.string(from: Date()) == "Sat" {
                weekDays.append("Sun")
                weekDays.append("Mon")
                weekDays.append("Tue")
                weekDays.append("Wed")
            } else if dateFormatter.string(from: Date()) == "Sun" {
                weekDays.append("Mon")
                weekDays.append("Tue")
                weekDays.append("Wed")
                weekDays.append("Thu")
            }
            
            self.day1.text = weekDays[0]
            self.day2.text = weekDays[1]
            self.day3.text = weekDays[2]
            self.day4.text = weekDays[3]
            self.day5.text = weekDays[4]
            
            self.temp1.text = "\(dataArray[0]["main"]["temp_min"])\u{00B0}F\n-\n\(dataArray[0]["main"]["temp_max"])\u{00B0}F"
            self.temp2.text = "\(dataArray[1]["main"]["temp_min"])\u{00B0}F\n-\n\(dataArray[1]["main"]["temp_max"])\u{00B0}F"
            self.temp3.text = "\(dataArray[2]["main"]["temp_min"])\u{00B0}F\n-\n\(dataArray[2]["main"]["temp_max"])\u{00B0}F"
            self.temp4.text = "\(dataArray[3]["main"]["temp_min"])\u{00B0}F\n-\n\(dataArray[3]["main"]["temp_max"])\u{00B0}F"
            self.temp5.text = "\(dataArray[4]["main"]["temp_min"])\u{00B0}F\n-\n\(dataArray[4]["main"]["temp_max"])\u{00B0}F"
            
            var urlArray: [URL] = []
            
            for urls in 0...dataArray.count-1 {
                let icony = dataArray[urls]["weather"][0]["icon"]
                print(icony)
                let iconURLy = URL(string: "http://openweathermap.org/img/w/\(icony).png")
                urlArray.append(iconURLy!)
            }
            
            self.image1.kf.setImage(with: urlArray[0])
            self.image2.kf.setImage(with: urlArray[1])
            self.image3.kf.setImage(with: urlArray[2])
            self.image4.kf.setImage(with: urlArray[3])
            self.image5.kf.setImage(with: urlArray[4])
            
            urlArray.removeAll()
        }
    }
    
    func requestCities() {
        let url = URL(string: "https://countriesnow.space/api/v0.1/countries/capital")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error); return }
            let jsony = JSON(data!)
            let newerData = jsony["data"].arrayValue
            print(newerData.count)
            
            for i in 0 ... newerData.count - 1 {
                self.cityArray.append(Cities(json: newerData[i]))
            }
            print(self.cityArray)
            self.populate(x: 5)
        }
        task.resume()
    }
}


