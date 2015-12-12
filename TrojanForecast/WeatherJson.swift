//
//  WeatherJson.swift
//  TrojanForecast
//
//  Created by Omender Sharma on 12/9/15.
//  Copyright © 2015 Omender Sharma. All rights reserved.
//

import Foundation

class WeatherJson {
    
    class var sharedInstance: WeatherJson {
        struct Static {
            static var instance: WeatherJson?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = WeatherJson()
        }
        
        return Static.instance!
    }
    
    var data : [String:AnyObject]!
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}