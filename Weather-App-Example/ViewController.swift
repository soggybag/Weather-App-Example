//
//  ViewController.swift
//  Weather-App-Example
//
//  Created by mitchell hudson on 10/6/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherServiceDelegate {
    
    let weatherService = WeatherService()
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    @IBAction func setCityTapped(sender: UIButton) {
        print("City Button Tapped")
        openCityAlert()
    }
    
    
    
    func openCityAlert() {
        // Create Alert Controller
        let alert = UIAlertController(title: "City",
            message: "Enter city name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create Cancel Action
        let cancel = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil)
        
        alert.addAction(cancel)
        
        // Create OK action
        let ok = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                print("OK")
                let textField = alert.textFields?[0]
                // print(textField?.text!)
                // self.cityLabel.text = textField?.text!
                let cityName = textField?.text
                self.weatherService.getWeather(cityName!)
        }
        
        alert.addAction(ok)
        
        // Add text field
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "City Name"
        }
        
        // Present Alert Controller
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Weather Service Delegate
    
    func setWeather(weather: Weather) {
        tempLabel.text = "\(weather.tempC)"
        descriptionLabel.text = weather.description
        cityButton.setTitle(weather.cityName, forState: .Normal)
        iconImage.image = UIImage(named: weather.icon)
        cloudsLabel.text = "\(weather.clouds)%"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.weatherService.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

