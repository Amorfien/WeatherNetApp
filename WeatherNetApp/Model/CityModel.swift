//
//  CityModel.swift
//  WeatherNetApp
//
//  Created by Pavel Grigorev on 04.04.2023.
//

import Foundation

struct CityElement: Codable {
    let name: String?
    let localNames: [String: String]?
    let lat, lon: Double?
    let country: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country
    }
}

