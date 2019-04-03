//
//  ChangeCityViewController.swift
//  weather
//
//  Created by Iva Cicarevic on 4/3/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}


class ChangeCityViewController: UIViewController {
    
    //instance
     var delegate : ChangeCityDelegate?
    
    
    //outlet
    @IBOutlet weak var changeCityName: UITextField!
    
    //action to get weather
    @IBAction func getWeather(_ sender: Any) {
        
        let cityName = changeCityName.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //action to back on WeatherVC
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
