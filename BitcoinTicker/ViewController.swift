//
//  ViewController.swift
//  BitcoinTicker
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let bitcoinDataModel = BitcoinData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bitcoinDataModel.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bitcoinDataModel.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bitcoinDataModel.currencyRow = row
        finalURL = baseURL + bitcoinDataModel.currencyArray[row]
        getBitcoinData(url: finalURL)
    }
    
    
    //    //MARK: - Networking
    //    /***************************************************************/
    
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }else{
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        if let bitcoinAverageToday = json["ask"].double {
            bitcoinDataModel.bitcoinAverageForTheDay = Double(round(bitcoinAverageToday*100)/100)
            bitcoinPriceLabel.text = bitcoinDataModel.currencySymbol[bitcoinDataModel.currencyRow] + String(bitcoinDataModel.bitcoinAverageForTheDay)
        }else{
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}
