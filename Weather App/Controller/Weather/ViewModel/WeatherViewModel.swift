//
//  WeatherViewModel.swift
//  MyWeatherApp
//
//  Created by Suresh on 29/03/23.
//

import Foundation
import UIKit

class WeatherViewModel {
    
    //MARK: - vars/lets
    var navigationBarTitle = Bindable<String?>(nil)
    var currentPressure = Bindable<String?>(nil)
    var currentHumidity = Bindable<String?>(nil)
    var currentDescription =  Bindable<String?>(nil)
    var currentTemperature = Bindable<String?>(nil)
    var currentFeelingWeather = Bindable<String?>(nil)
    var currentImageWeather = Bindable<UIImage?>(nil)
    var currentMinWeather = Bindable<String?>(nil)
    var currentMaxWeather = Bindable<String?>(nil)
    var currentWindSpeed = Bindable<String?>(nil)
    var currentTime = Bindable<String?>(nil)
    var backgroundImageView = Bindable<UIImage?>(nil)
    var currentWeatherObject = Bindable<CurrentWeather?>(nil)
    
    var weather = WeatherModel()

    //MARK: - flow func
    func addWeatherSettings() {
        guard let currentWeather = self.weather.currentWeather else { return }
        self.navigationBarTitle.value = currentWeather.name
        self.currentTime.value = dateFormater(date: currentWeather.dt, dateFormat: "HH:mm E")
        self.currentTemperature.value = "\(currentWeather.main.temp.doubleToString())°"
        self.currentFeelingWeather.value = "\(currentWeather.main.feels_like.doubleToString())°"
        self.currentMaxWeather.value = "\(currentWeather.main.temp_max.doubleToString())°"
        self.currentMinWeather.value = "\(currentWeather.main.temp_min.doubleToString())°"
        self.currentImageWeather.value = UIImage(named: "\(currentWeather.weather.first!.icon)-1.png")
        self.currentDescription.value = currentWeather.weather.first!.description.capitalizingFirstLetter()
        self.currentPressure.value = "\(currentWeather.main.pressure.doubleToString())мм"
        self.currentWindSpeed.value = "\(currentWeather.wind.speed)м/с"
        self.currentHumidity.value = "\(currentWeather.main.humidity.doubleToString())%"
        self.backgroundImageView.value = UIImage(named: "\(currentWeather.weather.first!.icon)-2")
    }

    func getWeather () {
        if weather.lat != nil && weather.lon != nil {
            weather.withGeolocationWeather {
                self.addWeatherSettings()
            }
        } else {
            weather.noGeolocationWeather {
                self.addWeatherSettings()
            }
     
        }
    }
    
    private func dateFormater(date: TimeInterval, dateFormat: String) -> String {
        let dateText = Date(timeIntervalSince1970: date )
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: weather.currentWeather?.timezone ?? 0)
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
        
    }
    
}

//MARK: - Extensions
extension WeatherViewModel: SearchViewModelDelegate {
    func setLocation(_ lat: Double, _ lon: Double) {
        self.weather.lon = lon
        self.weather.lat = lat
        getWeather()
    }
}

