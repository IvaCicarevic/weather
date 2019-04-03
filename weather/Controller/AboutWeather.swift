//
//  AboutWeather.swift
//  weather
//
//  Created by Iva Cicarevic on 4/3/19.
//  Copyright © 2019 Iva Cicarevic. All rights reserved.
//

import UIKit

class AboutWeather: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        
        self.view.addGestureRecognizer(swipe)
        swipe.direction = .right
        
    }
    
    @objc func handleGesture() {
        self.performSegue(withIdentifier: "toWeatherVC", sender: self)
    }
}

