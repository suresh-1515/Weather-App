//
//  WeatherModel.swift
//  MyWeatherApp
//
//  Created by Suresh on 28/03/23.
//

import Foundation

class WeatherModel {
    
    private var lang = Locale.current.languageCode
    var lat: Double?
    var lon: Double?
    var currentWeather: CurrentWeather?
    
    private let group = DispatchGroup()
    
    func withGeolocationWeather(completion: @escaping () -> ()) {
        group.enter()
            LocationWeatherManager.shared.getCurrentWeather(lat: lat!, lon: lon!, locale: lang!) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.group.leave()
            }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func noGeolocationWeather(completion: @escaping () -> ()) {
        group.enter()
            NoLocationWeatherManager.shared.getCurrentWeather(lang: lang!) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.group.leave()
            }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
}

