//
//  APImanager.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 29.03.2023.
//

import Foundation

final class APImanager {

//        https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//        http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&limit={limit}&appid={API key}
    // Небезопасное хранение ключа
    let myAPIkey = "a4c9600e55b24ecec540a7babde27e70"

    let tunnel = "https://"
    let server = "api.openweathermap.org/"

//    let lat: Double = 44.3
//    let lon: Double = 11.0

//    private enum ApiCases: String {
//        case currentWeather = "data/2.5/weather?lat={lat}&lon={lon}&appid={API key}"
//        case cityName = "1"
//        case cityLocation = "data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(myAPIkey)"
//    }

    private func session(endpoint: String, completion: @escaping (Result<Data, Error>) -> ()) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: "lat", value: <#T##String?#>)
        ]

        let urlStr = tunnel + server + endpoint

        // поддержка кириллицы в URL
        guard let apiURL = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("some Error")
            return
        }
        print(apiURL)
        let session = URLSession.shared



//        let request = URLRequest(url: apiURL)
//        request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)



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

    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<Data, Error>) -> ()) {

        let endpoint = "data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(myAPIkey)"
        session(endpoint: endpoint, completion: completion)

    }

    func getCityName(latitude: Double, longitude: Double, completion: @escaping (CityElement) -> ()) {
        let endpoint = "geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(myAPIkey)"

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

    func getCityLocation(name: String, completion: @escaping (Result<Data, Error>) -> ()) {
        let endpoint = "geo/1.0/direct?q=\(name)&limit=1&appid=\(myAPIkey)"
        session(endpoint: endpoint, completion: completion)
    }



}
