//
//  CityModel.swift
//  MyWeatherApp
//
//  Created by Suresh on 28/03/23.
//

import Foundation

class CityModel {
    
    var cities: [CityObject]?
    
    static let shared = CityModel()
    private init () {}
    
    func getCity() {
       let queue = DispatchQueue(label: "com.kirillSytkov.cityResponse")
       queue.async {
          CityManager.shared.getCity { [weak self] newCity in
              self?.cities = newCity
          }
       }
    }
}
