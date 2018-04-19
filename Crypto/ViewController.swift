//
//  ViewController.swift
//  Crypto$
//
//  Created by Shanthosh Pushparajah on 2018-04-17.
//  Copyright © 2018 Shanthosh Pushparajah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //TODO: API and Array Variables
    
    let baseURL = "https://min-api.cryptocompare.com/data/pricemulti?fsyms="
    var APIurl = ""
    var currencySymbol = ""
    var coinValue = ""
    var currencyValue = ""
    
    let currencyArray : [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "BTC", "ETH", "LTC", "XRP", "BCH", "ZEC", "DASH", "NEO", "XLM"]
    
    let currencySymbols : [String] = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R", "BTC", "ETH", "LTC", "XRP", "BCH", "ZEC", "DASH", "NEO", "XLM"]
    
    let coinArray : [String] = ["BTC", "ETH", "LTC", "XRP", "BCH", "ZEC", "DASH", "NEO", "XLM"]
    
    
    //IBOutlets for pickers and price
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var coinType: UIPickerView!
    @IBOutlet weak var currencyType: UIPickerView!
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //TODO: Overide
    
    override func viewDidLoad() {
        
        //Setup UIPicker
        coinType.delegate = self
        coinType.dataSource = self
        
        currencyType.delegate = self
        currencyType.dataSource = self
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //TODO: UIPickerView Delegate Methods
    
    
    
    
    //number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Used tags to tell diffence between UIPickers -> number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return coinArray.count
        } else {
            return currencyArray.count
        }
        
    }
    
    //Print array values
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return coinArray[row]
        }else{
            return currencyArray[row]
        }
    }
    
    //Determines what row UIPicker Value is on
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var x : Int = 0
        var y : Int = 0
        
        if (pickerView == coinType){
            print(coinArray[row])
            x = coinType.selectedRow(inComponent: 0)
            y = currencyType.selectedRow(inComponent: 0)
            print(x)
            
        }  else {
            
            print(currencyArray[row])
            x = coinType.selectedRow(inComponent: 0)
            y = currencyType.selectedRow(inComponent: 0)
            print(y)
            
        }
        
        coinValue = coinArray[x]
        currencyValue = currencyArray[y]
        
        //Creates the API url through the selected values
        APIurl = baseURL + coinValue + "&tsyms=" + currencyValue
        print(APIurl)
        
        currencySymbol = currencySymbols[y]
        
        //Set up variables to fetch JSON Data
        let tryConversion = false;
        let params : [String : Bool] = ["Value" : tryConversion]
        
        getCoinData(url: APIurl, parameters: params)
        
    }
    

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //TODO: Networking
    
    func getCoinData(url: String, parameters: [String : Bool]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                
                print("Sucess! Got data")
                
                let coinJSON : JSON = JSON(response.result.value!)
                
                print(coinJSON)
                
                self.updateCoinData(json: coinJSON)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //TODO: Parse JSON Data
    
    func updateCoinData(json : JSON) {
        
        if let coinResult = json[coinValue][currencyValue].double {
            
            priceLabel.text = currencySymbol + " " + String(coinResult)
            
            print(coinResult)
            
        } else {
            priceLabel.text = "Connection Issues"
        }
        
    }
    
}
