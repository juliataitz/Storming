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
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var percipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.locationManager = CLLocationManager()
//        self.locationManager?.requestWhenInUseAuthorization()
//        
//        var currentLocation = locationManager?.location
        
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()

    }
    
    func getCurrentWeatherData() -> Void{
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "40.7142,-74.0060", relativeToURL: baseURL)
        
        let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask =
        sharedSession.downloadTaskWithURL(forecastURL!,
            completionHandler: { (location: NSURL!, response:
                NSURLResponse!, error: NSError!) -> Void in
                
                if (error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    let currentWeather = Current(weatherDictionary: weatherDictionary)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.percipitationLabel.text = "\(currentWeather.precipProbability)"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        
                        //Stop refresh
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })
                }
                
        })
        downloadTask.resume()
    
    }

    
    @IBAction func refresh() {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

