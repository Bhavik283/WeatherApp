//
//  Weather.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 12/12/23.
//

import Foundation

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable {
    let humidity: Int
    let pressure: Int
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct WeatherData: Codable {
    let cod: Int
    let coord: Coordinate
    let id: Int
    let weather: [Weather]
    let main: Main
    let name: String

    var getImage: String {
        if weather[0].id < 300 {
            return "cloud.bolt.fill"
        } else if weather[0].id >= 300 && id < 400 {
            return "cloud.rain.fill"
        } else if weather[0].id >= 500 && id < 600 {
            return "cloud.heavyrain.fill"
        } else if weather[0].id >= 600 && id < 700 {
            return "cloud.snow.fill"
        } else if weather[0].id >= 700 && id < 800 {
            return "smoke.fill"
        } else if weather[0].id == 800 {
            return "sun.max.fill"
        } else {
            return "cloud.fill"
        }
    }
}

// {
//    coord =     {
//        lat = "28.6667";
//        lon = "77.2167";
//    };
//    main =     {
//        humidity = 38;
//        pressure = 1013;
//        temp = "23.05";
//    };
//    name = Delhi;
//    weather =     (
//                {
//            id = 721;
//            main = Haze;
//        }
//    );
// }
