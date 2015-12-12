//
//  ViewController.swift
//  TrojanForecast
//
//  Created by Omender Sharma on 11/19/15.
//  Copyright © 2015 Omender Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource {

    @IBOutlet var ImageView: UIImageView!
    
    @IBOutlet var TextField1: UITextField!
    
    @IBOutlet var TextField2: UITextField!
   
    @IBOutlet var Picker1: UIPickerView!
   
    @IBOutlet var Picker2: UIPickerView!
   
    @IBOutlet var Button1: UIButton!
    
    @IBOutlet var Button2: UIButton!
   
    @IBOutlet var errorconsole: UILabel!
    let stateValues = ["Select","Alabama","Alaska","American Samoa","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District Of Columbia","Federated States Of Micronesia","Florida","Georgia","Guam","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Marshall Islands","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Northern Mariana Islands","Ohio","Oklahoma","Oregon","Palau","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virgin Islands","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    let stateKeys = ["NULL","AL","AK","AS","AZ","AR","CA","CO","CT","DE","DC","FM","FL","GA","GU","HI","ID","IL","IN","IA","KS","KY","LA","ME","MH","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","MP","OH","OK","OR","PW","PA","PR","RI","SC","SD","TN","TX","UT","VT","VI","VA","WA","WV","WI","WY"]
    let degreeValues = ["Fahrenheit", "Celsius"]
    let degreeKeys = ["f", "c"]
    var stateKey = "NULL"
    var degreeKey = "f"
    
        override func viewDidLoad() {
        super.viewDidLoad()
        _ = AFURLConnectionOperation()
        self.Picker1.dataSource = self;
        self.Picker2.dataSource = self;
        self.Picker1.delegate = self
        self.Picker2.delegate = self
        self.TextField1.delegate = self
        self.TextField2.delegate = self
        
        
      //  Picker1.hidden = true
      //  Picker2.hidden = true
        errorconsole.text = ""
       // TextField1.text = stateValues[0]
      //  TextField2.text = degreeValues[0]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func aboutBtnPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("about", sender: self);
    }
    
    @IBAction func ClearForm(sender: AnyObject) {
        TextField1.text = ""
        TextField2.text = ""
    }
    
    
    
     func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == Picker1 {
            return stateValues.count
        } else {
            return degreeValues.count
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == Picker1 {
            return stateValues[row]
        } else {
            return degreeValues[row]
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == Picker1 {
            //TextField1.text = stateValues[row]
            stateKey = stateKeys[row]
           // statePicker.hidden = true
        } else {
            //TextField.text = degreeValues[row]
            degreeKey = degreeKeys[row]
           // degreePicker.hidden = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        TextField1.resignFirstResponder()
        TextField2.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func SearchForm(sender: AnyObject) {
        if TextField1.text == "" {
                       errorconsole.text = "Please input street"
                   } else if TextField2.text == "" {
                       errorconsole.text = "Please input city"
                 } else if stateKey == "NULL" {
                       errorconsole.text = "Please select state"
                  } else {
                     // do request
                      errorconsole.text = ""
            let urlString = "http://omihw8-env.elasticbeanstalk.com/Forecast.php?street=\(self.TextField1.text!)&city=\(self.TextField2.text!)&state=\(stateKey)&degree=\(degreeKey)&submit="
            get(urlString, successHandler: handleResponse)
        }
        
        
        
    }
    func get(url : String, successHandler: (response: String) -> Void) {
        let url = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                return
            }
            
            let responseString : String = String(data: data!, encoding: NSUTF8StringEncoding)!
            successHandler(response: responseString)
        }
        task.resume();
    }
    
    func handleResponse(response: String) -> Void {
        // init model
        let weatherJson = WeatherJson.sharedInstance
        weatherJson.data = weatherJson.convertStringToDictionary(response)
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showResult", sender: self)
        }
    }
    

    @IBAction func forecastIOPressed(sender: AnyObject) {
        
        var webView: UIWebView! = UIWebView(frame: CGRectMake(0,64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        let url = NSURL (string: "http://forecast.io");
        
        let requestObj = NSURLRequest(URL: url!);
        
        webView.loadRequest(requestObj);
        
        self.view.addSubview(webView);


        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showResult"
        {
            var dest:ResultViewController  = segue.destinationViewController as! ResultViewController
            dest.street = self.TextField1.text
            dest.city = self.TextField2.text
            dest.state = stateKey

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

