//
//  WeatherManager.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 08.04.2023.
//

import Foundation

enum WeatherManager {

//    func getForecastByDay(coordinates: (Double, Double), timezone: Double) -> [String, String] {}

    static func getInfoByName(cityName: String, comletion: @escaping (CurrentWeatherModel, ForecastWeatherModel) -> Void) {

        let apiManager = APImanager.shared

        apiManager.getCityLocation(name: cityName) { searchCity in
            guard let latitude = searchCity.lat, let longitude = searchCity.lon else { return }
            apiManager.get5dayForecast(latitude: latitude, longitude: longitude) { forecast in

                apiManager.getCurrentWeather(latitude: latitude, longitude: longitude) { weather in
                    comletion(weather, forecast)
                }
            }
        }

    }

    static func getInfoByCoord(latitude: Double, longitude: Double, comletion: @escaping (CurrentWeatherModel, ForecastWeatherModel) -> Void) {

        let apiManager = APImanager.shared

        apiManager.get5dayForecast(latitude: latitude, longitude: longitude) { forecast in

            apiManager.getCurrentWeather(latitude: latitude, longitude: longitude) { weather in
                comletion(weather, forecast)
            }
        }
    }




}
