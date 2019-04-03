//
//  WeatherViewController.swift
//  weather
//
//  Created by Iva Cicarevic on 4/3/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    //constants
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "1d1db656fa6c3d482c880d1a9b1cb0f8"
 

    //instance variables
    let locationManager = CLLocationManager()
    let weatherModel = WeatherModel()
    
    
    //outlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var changeCityButton: UIButton!
  
    @IBAction func aboutWeather(_ sender: UIButton) {
        performSegue(withIdentifier: "toAboutWeather", sender: self)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //getWeatherData method
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //updateWeatherData method
    
    
    func updateWeatherData(json : JSON) {
        
        let tempResult = json["main"]["temp"].doubleValue
        
        weatherModel.temperature = Int(tempResult - 273.15)
        
        weatherModel.city = json["name"].stringValue
        
        weatherModel.condition = json["weather"][0]["id"].intValue
        
        weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)
        
        
        updateUIWithWeatherData()
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    //updateUIWithWeatherData method
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherModel.city
        temperatureLabel.text = "\(weatherModel.temperature)°"
        weatherImage.image = UIImage(named: weatherModel.weatherIconName)
    
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let par : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : appID]
            
            getWeatherData(url: weatherURL, parameters: par)
        }
    }
    
    
    //didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    //userEnteredANewCityName Delegate method
    func userEnteredANewCityName(city: String) {
        
        let par : [String : String] = ["q" : city, "appid" : appID]
        
        getWeatherData(url: weatherURL, parameters: par)
        
    }

    
    //prepareForSegue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            
            destinationVC.delegate = self
        }
    }
}
