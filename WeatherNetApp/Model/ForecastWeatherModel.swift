//
//  ForecastWeatherModel.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 04.04.2023.
//

import Foundation

struct ForecastWeatherModel: Codable {
    let list: [List]?
    let city: City3h?
}

// MARK: - City
struct City3h: Codable {
    let id: Int?
    let name: String?
    let coord: Coord3h?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coord3h: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather3h]?
    let clouds: Clouds3h?
    let wind: Wind3h?
    let visibility: Int?
    let pop: Double?
    let rain: Rain3h?
    let snow: Snow3h?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop
        case rain, snow
    }
}

// MARK: - Clouds
struct Clouds3h: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain3h: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Snow
struct Snow3h: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Weather
struct Weather3h: Codable {
    let id: Int?
    let main: String?
    let description, icon: String?
}

// MARK: - Wind
struct Wind3h: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
