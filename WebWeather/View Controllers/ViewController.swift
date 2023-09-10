//
//  ViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import UIKit

final class ViewController: UIViewController {
    @IBAction private func getWeatherButtonTapped() {
        fetchWeather()
    }
    
    private func fetchWeather() {
        URLSession.shared.dataTask(with: RequestURL.getURL()) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let weather = try decoder.decode(Weather.self, from: data)
                print(weather)
                DispatchQueue.main.async { [unowned self] in
                    self?.showAlert(weather)
                }
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async { [unowned self] in
                    self?.showFailAlert()
                }
            }
        }.resume()
    }
    
    private func showAlert(_ weather: Weather) {
        var forecast = ""
        
        for index in 1..<weather.forecasts.count {
            let forecastWeather = weather.forecasts[index]
            forecast += "\n\n"
            forecast += "\(forecastWeather.date):\n"
            forecast += "morning: \(forecastWeather.parts.morning.temp_avg)°C, feels like \(forecastWeather.parts.morning.feels_like)°C, \(forecastWeather.parts.morning.condition)\n"
            forecast += "day: \(forecastWeather.parts.day.temp_avg)°C, feels like \(forecastWeather.parts.day.feels_like)°C, \(forecastWeather.parts.day.condition)\n"
            forecast += "evening: \(forecastWeather.parts.evening.temp_avg)°C, feels like \(forecastWeather.parts.evening.feels_like)°C, \(forecastWeather.parts.evening.condition)\n"
            forecast += "night: \(forecastWeather.parts.night.temp_avg)°C, feels like \(forecastWeather.parts.night.feels_like)°C, \(forecastWeather.parts.night.condition)"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(
            from: Date(
                timeIntervalSince1970: TimeInterval(weather.now)
            )
        )
        
        let alert = UIAlertController(
            title: "Weather in \(weather.geo_object.country.name), \(weather.geo_object.province.name)",
            message: """
                     Today - \(date)
                     
                     Today is \(weather.fact.temp)°C, feels like \(weather.fact.feels_like)°C, \(weather.fact.condition)
                     
                     Forecast:\(forecast)
                     """,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showFailAlert() {
        let alert = UIAlertController(
            title: "Something went wrong",
            message: "Details in Debug Area",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
