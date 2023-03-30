//
//  LocationWeatherManager.swift
//  MyWeatherApp
//
//  Created by Suresh on 29/03/23.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}

class LocationWeatherManager {
    
    static let shared = LocationWeatherManager()
    private let key = "1c2ba745810db56a9f945361a2520a0a"
    
    private init() {}
 
    func getCurrentWeather(lat:Double,lon:Double,locale: String,completion: @escaping (Result<CurrentWeather,NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=\(locale)&units=metric&appid=\(key)") else {
            completion(.failure(.serverError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
 
    }
    
}





