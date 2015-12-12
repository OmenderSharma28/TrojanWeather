//
//  ResultViewController.swift
//  TrojanForecast
//
//  Created by Omender Sharma on 12/9/15.
//  Copyright © 2015 Omender Sharma. All rights reserved.
//

import Foundation

import UIKit

import FBSDKLoginKit

import FBSDKShareKit


class ResultViewController: UIViewController , FBSDKSharingDelegate{
    
    @IBOutlet var summaryTmage1: UIImageView!
    
    @IBOutlet var summaryLabel1: UILabel!
   
    @IBOutlet var tempLabel1: UILabel!
   
    @IBOutlet var upprAndLower1: UILabel!
    
    
    
    @IBOutlet var precipitation: UILabel!
    
    
    @IBOutlet var chanceOfRain: UILabel!
   
    
    @IBOutlet var WindSpeed1: UILabel!
    
   
   
    @IBOutlet var DewPoint: UILabel!
   
    
    @IBOutlet var Humidity: UILabel!
  
   
    @IBOutlet var Visibility: UILabel!
   

    @IBOutlet var Sunrise: UILabel!
    
    
    
    @IBOutlet var Sunset: UILabel!
    
    var data:AnyObject!
    var street:String!
    var city:String!
    var state:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
         data = WeatherJson.sharedInstance.data
        summaryTmage1.image = UIImage(data:NSData(contentsOfURL:NSURL(string:data["currently"]!!["image_url"] as! String)!)!);
        summaryLabel1.text = (data["summary"] as? String)!
        tempLabel1.text = data["temp_label"] as? String
        upprAndLower1.text = data["upper_and_lower"] as? String
        precipitation.text = data["percipitation"] as? String
        chanceOfRain.text = data["chance_of_rain"] as? String
        WindSpeed1.text = data["wind_speed"] as? String
        DewPoint.text = data["dew_point"] as? String
        Humidity.text = data["humidity"] as? String
        Visibility.text = data["visibility"] as? String
       // Sunrise.text = data["sunrise"] as? String
       // Sunset.text = data["sunset"] as? String
    }
    
    
    @IBAction func viewMapPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("mapSegue", sender: self)

    }
    
    @IBAction func fbButtonPressed(sender: AnyObject) {
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            self.publishToWall()
        }
        else
        {
            let loginView : FBSDKLoginManager = FBSDKLoginManager()
            loginView.logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (result, error) -> Void in
                
                if error == nil
                {
                    self.publishToWall()
                }
            })
        }
        
    }
    
    func publishToWall() -> Void
    {
        var properties:[String:AnyObject] =
        [   "og:type": "fitness.course",
            "og:title": "Current Weather in \(city)",
            "og:image":data["currently"]!["image_url"] as! String,
            "og:description": "56 F \n Forecast.io",
        ];

        var object:FBSDKShareOpenGraphObject = FBSDKShareOpenGraphObject(properties: properties)
        
        var action:FBSDKShareOpenGraphAction = FBSDKShareOpenGraphAction()
        
        action.actionType = "fitness.run"
        
        action.setObject(object, forKey: "fitness:course")
        
        var content:FBSDKShareOpenGraphContent = FBSDKShareOpenGraphContent()
        
        content.action = action
        
        content.previewPropertyName = "fitness:course"
        
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    @IBAction func moreDetailsBtnPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("moreDetailsSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "moreDetailsSegue"
        {
            let destVC:DetailsViewController = segue.destinationViewController as! DetailsViewController
            destVC.jsonObject = data!
        }
    }

    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!)
    {
        JLToast.makeText("Share completed").show()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!)
    {
        JLToast.makeText(error.description).show()
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!)
    {
        JLToast.makeText("Share canceled").show()

    }

}
