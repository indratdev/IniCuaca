//
//  WeatherModel.swift
//  IniCuaca
//
//  Created by IndratS on 12/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]
    let base: String?
    let main: Main?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
    let visibility: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, pressure: Double?
    let humidity: Int?
    let temp_min, temp_max, seaLevel, grndLevel: Double?

//    enum CodingKeys: String, CodingKey {
//        case temp, pressure, humidity
//        case tempMin
//        case tempMax
//        case seaLevel
//        case grndLevel
//    }
}

// MARK: - Sys
struct Sys: Codable {
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?

//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription
//        case icon
//    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
