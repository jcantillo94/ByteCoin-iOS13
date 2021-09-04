//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Jose Cantillo on 9/3/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let id : String
    let rate : Double
    
    var getRateAsString: String {
        return String(format: "%.2f", rate)
    }
}
