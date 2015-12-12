//
//  AerisMapVC.swift
//  TrojanForecast
//
//  Created by Gaurav Nijhara on 12/10/15.
//  Copyright © 2015 Omender Sharma. All rights reserved.
//

import UIKit

class AerisMapVC: AWFWeatherMapViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var mapImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = [UIColor blackColor];
//        
//        //	self.weatherMap.timelineStartDate = [NSDate dateWithTimeIntervalSinceNow:12 * 3600];
//        //	self.weatherMap.timelineEndDate = [NSDate dateWithTimeIntervalSinceNow:24 * 3600];
//        
//        // get default location's coordinates to set the map region to
//        AWFPlace *place = [[UserLocationsManager sharedManager] defaultLocation];
//        if (place) {
//            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([place.latitude floatValue], [place.longitude floatValue]);
//            NSInteger zoom = (self.weatherMap.weatherMapType == AWFWeatherMapTypeGoogle) ? 8 : 7;
//            [self.weatherMap setMapCenterCoordinate:coord zoomLevel:zoom animated:YES];
//        }
//
        
        self.view.backgroundColor = UIColor.blackColor();
        

        var config:AWFWeatherMapConfig = AWFWeatherMapConfig()
        config.tileOverlayAlpha = 0.8
        config.tileOverlayLevel = MKOverlayLevel.AboveLabels
        config.refreshInterval = 15 * AWFMinuteInterval
        config.animationEnabled = true
        config.animationDuration = 2.0
        config.animationEndDelay = 2.0
        config.animationCrossfadeEnabled = false
        config.maximumIntervalsForAnimation = 20
        config.timelineStartOffsetFromNow = -2*3600
        config.timelineEndOffsetFromNow = 0
        
        
//        self.refreshInterval = 15 * AWFMinuteInterval;
//        self.animationEnabled = NO;
        self.weatherMapType = AWFWeatherMapType.Google;
        self.config = config;
        
        
        self.weatherMap.timelineStartDate = NSDate(timeIntervalSinceNow: 12*3600)
        self.weatherMap.timelineEndDate = NSDate(timeIntervalSinceNow: 24*3600)
        
        let place:AWFPlace! = AWFPlace(city: "Los Angeles", state: "ca", country: "usa")
        let loader:AWFPlacesLoader = AWFPlacesLoader()
        
        loader.getPlace(place, options: nil) { (objects, error) -> Void in
            if(error != nil)
            {
                return;
            }

            let arr:NSArray = (objects as NSArray);

            if arr.count > 0
            {
                let place:AWFPlace! = arr.objectAtIndex(0) as! AWFPlace
                if place != nil
                {
                    let coord:CLLocationCoordinate2D = CLLocationCoordinate2DMake((place.latitude.doubleValue), (place?.longitude.doubleValue)!)
                    let zoom:UInt = 8
                    self.weatherMap.setMapCenterCoordinate(coord, zoomLevel:zoom, animated: false)

                }

            }

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.weatherMap.addLayerType(AWFLayerType.Radar)
        self.weatherMap.addLayerType(AWFLayerType.Satellite)
        
        self.weatherMap.refreshAllLayerTypes()
        
        self.weatherMap.enableAutoRefresh()
        
        self.view.addSubview(self.weatherMap.weatherMapView)

        
    }
}
