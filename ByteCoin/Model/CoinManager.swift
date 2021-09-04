//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=D6368C58-7135-4040-A99C-51EC33EC53F6"
    var currencySelected : String?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let coinURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    var delegate: CoinManagerDelegate?

    mutating func getCoinPrice(for currency: String) {
        
        currencySelected = currency
        if let currencySelected = currencySelected {
//            print(currencySelected)
            let urlString = "\(coinURL)/" + currencySelected + apiKey
            performRequest(with: urlString)
            print("getCoinPrice")
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin:coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let id = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(id: id, rate: rate)
            return coin
        }
        
        catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
