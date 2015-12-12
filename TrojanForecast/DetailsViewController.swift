//
//  DetailsViewController.swift
//  TrojanForecast
//
//  Created by Gaurav Nijhara on 12/10/15.
//  Copyright © 2015 Omender Sharma. All rights reserved.
//

import Foundation

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var jsonObject: AnyObject!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var next24HoursBtn: UIButton!
    @IBOutlet weak var next7DaysBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    var _daysMode:Bool!
    var _hoursDict:NSArray!
    var _daysDict:NSArray!
    var pages:Int = 1
    
    override func viewDidLoad() {
        _daysMode = false;
        
        _hoursDict = jsonObject["hourly"] as! NSArray
        _daysDict = jsonObject["daily"] as! NSArray
        
    }
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        if(_daysMode == true)
        {
            return 44;
        }
        else
        {
            return 0;
        }

     }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(_daysMode == true)
        {
            let header:UIView = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,44))
            
            let dynamicLabel: UILabel = UILabel()
            dynamicLabel.frame = CGRectMake(16, 11, 38, 21)
            dynamicLabel.font = UIFont.systemFontOfSize(17)
            dynamicLabel.textColor = UIColor.blackColor()
            dynamicLabel.textAlignment = NSTextAlignment.Center
            dynamicLabel.text = "Time"
            header.addSubview(dynamicLabel)
            
            let dynamicLabel2: UILabel = UILabel()
            dynamicLabel2.frame = CGRectMake(50, 150, 200, 21)
            dynamicLabel2.font = UIFont.systemFontOfSize(17)
            dynamicLabel2.textColor = UIColor.blackColor()
            dynamicLabel2.textAlignment = NSTextAlignment.Center
            dynamicLabel2.center = header.center
            dynamicLabel2.text = "Summary"
            header.addSubview(dynamicLabel2)

            let dynamicLabel3: UILabel = UILabel()
            dynamicLabel3.frame = CGRectMake(header.frame.size.width-80,11,80, 21)
            dynamicLabel3.font = UIFont.systemFontOfSize(17)
            dynamicLabel3.textColor = UIColor.blackColor()
            dynamicLabel3.textAlignment = NSTextAlignment.Center
            dynamicLabel3.text = "Temp(F)"
            header.addSubview(dynamicLabel3)
            
            header.backgroundColor = UIColor(colorLiteralRed:117/255.0, green: 235/255.0, blue: 224/255.0, alpha: 1)

            return header
        }

        return nil
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(_daysMode == true)
        {
            if(pages*24 < _hoursDict.count)
            {
                return (pages*24 + 1)
            }
            else
            {
                return _hoursDict.count;
            }
        }
        else
        {
            return _daysDict.count;
        }
        
    }
    
    @IBAction func loadMorePressed(sender: AnyObject) {
        
        pages += 1
        tableView.reloadData()
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var resuseIdentifier:String
        
        if((_daysMode) == true)
        {
            //            if()

            if(pages*24 < _hoursDict.count && indexPath.row == pages*24)
            {
                resuseIdentifier = "loadMoreCell";
                return tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath)

            }
            else
            {
        
                resuseIdentifier = "dailyCell";
                let cell:Next24HoursTableViewCell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! Next24HoursTableViewCell
                cell.timeLabel.text = (_hoursDict[indexPath.row] as! NSDictionary)["time"] as? String
                cell.tempLabel.text = (_hoursDict[indexPath.row] as! NSDictionary)["temperature"] as? String
                cell.summaryImg.image = UIImage(data:NSData(contentsOfURL:NSURL(string:((_hoursDict[indexPath.row] as! NSDictionary)["image_url"] as! String))!)!);
                
                cell.backgroundColor = UIColor.whiteColor()
                
                if indexPath.row % 2 == 0
                {
                    cell.backgroundColor = UIColor.lightGrayColor()
                }
                
                return cell;

            }
        }
        else
        {
            resuseIdentifier = "weeklyCell";
            
            let cell:Next7DaysTableViewCell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! Next7DaysTableViewCell
            
            cell.titleLabel.text = (_daysDict[indexPath.row] as! NSDictionary)["week_date"] as? String
            cell.low.text = (_daysDict[indexPath.row] as! NSDictionary)["temperature_min"] as? String
            cell.high.text = (_daysDict[indexPath.row] as! NSDictionary)["temperature_max"] as? String
            cell.summaryImagr.image = UIImage(data:NSData(contentsOfURL:NSURL(string:((_daysDict[indexPath.row] as! NSDictionary)["image_url"] as! String))!)!);
            
            var randomRed:CGFloat = CGFloat(drand48())
            
            var randomGreen:CGFloat = CGFloat(drand48())
            
            var randomBlue:CGFloat = CGFloat(drand48())
            
            cell.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 0.3)

            return cell;

            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(_daysMode == true)
        {
            return 50;
        }
        else
        {
            return 90;
        }

    }
    
    @IBAction func next24HoursPressed(sender: AnyObject) {
        
        if(!_daysMode)
        {
            _daysMode = true;
            tableView!.reloadData();
        }
    }
    
    @IBAction func next7DaysPressed(sender: AnyObject) {
        
        if((_daysMode) != nil)
        {
            _daysMode = false;
            tableView!.reloadData();
        }

    }
}
