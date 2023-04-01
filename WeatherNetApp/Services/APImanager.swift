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
        // Б - безопасность
        let encodAPI: [UInt8] = [0x61, 0x34, 0x63, 0x39, 0x36, 0x30, 0x30, 0x65, 0x35, 0x35, 0x62, 0x32, 0x34, 0x65, 0x63, 0x65, 0x63, 0x35, 0x34, 0x30, 0x61, 0x37, 0x62, 0x61, 0x62, 0x64, 0x65, 0x32, 0x37, 0x65, 0x37, 0x30]

        let data = Data(encodAPI)
        self.myAPIkey = String(data: data, encoding: .utf8)!
    }

    let tunnel = "https://"
    let server = "api.openweathermap.org/"

    private enum Endpoint: String {
        case getCurrentWeather = "data/2.5/weather"
        case getCityName = "geo/1.0/reverse"
        case getCityLocation = "geo/1.0/direct"
    }

    private func session(endpoint: String, completion: @escaping (Result<Data, Error>) -> ()) {

        let urlStr = tunnel + server + endpoint

        // поддержка кириллицы в URL
        guard let apiURL = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("some Error")
            return
        }
//        print(apiURL)
        let session = URLSession.shared

        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
        task.resume()
    }

    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeatherData) -> ()) {

//        let endpoint = "data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(myAPIkey)"
        let endpoint = "data/2.5/weather?lat=\(latitude)&lon=\(longitude)&lang=ru&units=metric&appid=\(myAPIkey)"
        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                    completion(weather)
                } catch {

                }

            case .failure(let error): print(error)
            }
        }

    }

    func getCityName(latitude: Double, longitude: Double, completion: @escaping (CityElement) -> ()) {
        let endpoint = "geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=1&lang=ru&appid=\(myAPIkey)"

        session(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let cities = try JSONDecoder().decode([CityElement].self, from: data)
                    completion(cities.first!)
                } catch {

                }

            case .failure(let error): print(error)
            }
        }
    }

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
                } catch {

                }

            case .failure(let error): print(error)
            }
        }
    }



}
