//
//  WeatherService.swift
//  Weather-App-Example
//
//  Created by mitchell hudson on 10/6/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather: Weather)
    func weatherErrorWithMessage(message: String)
}

class WeatherService {
    
    var delegate: WeatherServiceDelegate?
    
    
    func getWeather(city: String) {
        
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let appid = "2854c5771899ff92cd962dd7ad58e7b0"
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=\(appid)"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // print(">>>> \(data)")
            
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            let json = JSON(data: data!)
            print(json)
            
            // Get the cod code: 401 Unauthorized, 404 file not found, 200 Ok!
            // ! OpenWeatherMap returns 404 as a string but 401 and 200 are Int!?
            
            var status = 0
            if let cod = json["cod"].int {
                status = cod
            } else if let cod = json["cod"].string {
                status = Int(cod)!
            }
            
            // Check status
            print("Weather status code:\(status)")
            
            if status == 200 {
                let lon = json["coord"]["lon"].double
                let lat = json["coord"]["lat"].double
                let temp = json["main"]["temp"].double
                let tempMin = json["main"]["temp_min"].double
                let tempMax = json["main"]["temp_max"].double
                let humidity = json["main"]["humidity"].double
                let pressure = json["main"]["pressure"].double
                let name = json["name"].string
                let desc = json["weather"][0]["description"].string
                let icon = json["weather"][0]["icon"].string
                let clouds = json["clouds"]["all"].double
                
                let weather = Weather(
                    cityName: name!,
                    temp: temp!,
                    description: desc!,
                    icon: icon!,
                    clouds: clouds!,
                    tempMin: tempMin!,
                    tempMax: tempMax!,
                    humidity: humidity!,
                    pressure: pressure!
                )
                
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                }
            } else if status == 404 {
                // There doesn't seem to be a city with than name?
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("City could not be found")
                    })
                }
            } else if status == 401 {
                // Unauthorized
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("Unauthorized error")
                    })
                }
            } else {
                // Unidentified error
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("Something untoward has happened")
                    })
                }
            }
        }
        
        task.resume()
    }
    
}
