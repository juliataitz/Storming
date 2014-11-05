//
//  ViewController.swift
//  Storming
//
//  Created by Julia Taitz on 10/26/14.
//  Copyright (c) 2014 Julia Taitz. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let apiKey = "ae2fb2d6492878aaab8d12549caabbff"
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        
        var currentLocation = locationManager?.location
        println("\(currentLocation?.coordinate.latitude)")
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)
        
        let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)
        //prettyjson.com
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask =
            sharedSession.downloadTaskWithURL(forecastURL!,
            completionHandler: { (location: NSURL!, response:
            NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                println(currentWeather.currentTime!)
                
            }

        })
        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

