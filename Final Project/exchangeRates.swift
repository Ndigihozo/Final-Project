//
//  exchangeRates.swift
//  Final Project
//
//  Created by d.igihozo on 4/28/23.
//

import Foundation

//Declaring a new struct called exchangeRates that conforms to the Codable protocol.
struct exchangeRates: Codable{
    
    //Declaring a property called rates which is a dictionary of type [String: Double]. The keys in this dictionary are currency codes and the values are exchange rates for those currencies.
    let rates: [String: Double]
}
