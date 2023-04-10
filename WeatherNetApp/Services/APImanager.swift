//
//  APImanager.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 29.03.2023.
//

import Foundation

final class APImanager {

    static let shared = APImanager()

    private let myAPIkey: String

    private init() {
        /// обфускация личного API-ключа для погодного сервиса
        let encodAPI: [UInt8] = [0x61, 0x34, 0x63, 0x39, 0x36, 0x30, 0x30, 0x65, 0x35, 0x35, 0x62, 0x32, 0x34, 0x65, 0x63, 0x65, 0x63, 0x35, 0x34, 0x30, 0x61, 0x37, 0x62, 0x61, 0x62, 0x64, 0x65, 0x32, 0x37, 0x65, 0x37, 0x30]
        let data = Data(encodAPI)
        self.myAPIkey = String(data: data, encoding: .utf8)!
    }

    let tunnel = "https://"
    let server = "api.openweathermap.org/"

    // MARK: - URL session
    private func session(endpoint: String, completion: @escaping (Result<Data, Error>) -> ()) {

        let urlStr = tunnel + server + endpoint
        // поддержка кириллицы в URL
        guard let apiURL = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("some Error")
            return
        }
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }

    // MARK: - JSONDecoder current weather
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeatherModel) -> ()) {
        let endpoint = "data/2.5/weather?lat=\(latitude)&lon=\(longitude)&lang=ru&units=metric&appid=\(myAPIkey)"
        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    completion(weather)
                } catch {}
            case .failure(let error): print(error)
            }
        }
    }

    // MARK: - JSONDecoder city by coordinates
    func getCityName(latitude: Double, longitude: Double, completion: @escaping (CityElement) -> ()) {
        let endpoint = "geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=1&lang=ru&appid=\(myAPIkey)"
        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let cities = try JSONDecoder().decode([CityElement].self, from: data)
                    completion(cities.first!)
                } catch {}
            case .failure(let error): print(error)
            }
        }
    }

    // MARK: - JSONDecoder city by name
    func getCityLocation(name: String, completion: @escaping (CityElement) -> ()) {
        let endpoint = "geo/1.0/direct?q=\(name)&limit=1&lang=ru&appid=\(myAPIkey)"
        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let cities = try JSONDecoder().decode([CityElement].self, from: data)
                    if let city = cities.first {
                        completion(city)
                    }
                } catch {}
            case .failure(let error): print(error)
            }
        }
    }

    // MARK: - JSONDecoder forecast weather
    func get5dayForecast(latitude: Double, longitude: Double, completion: @escaping (ForecastWeatherModel) -> ()) {
        let endpoint = "data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&lang=ru&units=metric&appid=\(myAPIkey)"
        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
                    completion(weather)
                } catch {}
            case .failure(let error): print(error)
            }
        }
    }

    // MARK: - summary info by city name
    func getInfoByName(cityName: String, comletion: @escaping (CurrentWeatherModel, ForecastWeatherModel) -> Void) {

        getCityLocation(name: cityName) { searchCity in
            guard let latitude = searchCity.lat, let longitude = searchCity.lon else { return }
            self.get5dayForecast(latitude: latitude, longitude: longitude) { forecast in

                self.getCurrentWeather(latitude: latitude, longitude: longitude) { weather in
                    comletion(weather, forecast)
                }
            }
        }

    }

    // MARK: - summary info by coordinates
    func getInfoByCoord(latitude: Double, longitude: Double,
                        comletion: @escaping (CurrentWeatherModel, ForecastWeatherModel) -> Void) {

        get5dayForecast(latitude: latitude, longitude: longitude) { forecast in

            self.getCurrentWeather(latitude: latitude, longitude: longitude) { weather in
                comletion(weather, forecast)
            }
        }
    }

}
