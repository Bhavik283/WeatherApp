//
//  APICaller.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 12/12/23.
//

import Foundation

protocol APIDelegate {
    func getSuccess(weatherData: WeatherData)
    func getFailure(error: Error)
}

enum Constants {
    static let API_Key = "hidden"
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    static let cordURL = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()

    var delegate: APIDelegate?

    func getWeather(with query: String) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)q=\(query)&units=metric&appid=\(Constants.API_Key)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(WeatherData.self, from: data)
                self.delegate?.getSuccess(weatherData: results)
                print(results)
            } catch {
                self.delegate?.getFailure(error: error)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func getWeatherCoord(with lon: Double, lat: Double) {
        guard let url = URL(string: "\(Constants.baseURL)lat=\(lat)&lon=\(lon)&appid=\(Constants.API_Key)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(WeatherData.self, from: data)
                self.delegate?.getSuccess(weatherData: results)
                print(results)
            } catch {
                self.delegate?.getFailure(error: error)
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
}
