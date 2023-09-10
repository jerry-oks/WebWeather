//
//  Weather.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import Foundation

struct Weather: Decodable {
    let now: Int
    let geo_object: GeoObject
    let fact: FactWeather
    let forecasts: [DayForecastWeather]
}

struct FactWeather: Decodable {
    let condition: String
    let temp: Int
    let feels_like: Int
}

struct GeoObject: Decodable {
    let country: GeoObjectName
    let province: GeoObjectName
}

struct GeoObjectName: Decodable {
    let name: String
}

struct DayForecastWeather: Decodable {
    let date: String
    let parts: PartOfTheDayWeather
}

struct PartOfTheDayWeather: Decodable {
    let morning: WeatherCondition
    let day: WeatherCondition
    let evening: WeatherCondition
    let night: WeatherCondition
}

struct WeatherCondition: Decodable {
    let condition: String
    let temp_avg: Int
    let feels_like: Int
}

struct RequestURL {
    let lat: String
    let lon: String
    let lang: String
    let limit: String
    let hours: String
    let extra: String
    let key: String
    
    static func getURL() -> URLRequest {
        let requestUrl = RequestURL(
            lat: "55.751244",
            lon: "37.618423",
            lang: "en_US",
            limit: "4",
            hours: "false",
            extra: "false",
            key: "f5218a8d-a6a9-4096-bac4-add967d8bc77"
        )

        let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(requestUrl.lat)&lon=\(requestUrl.lon)&lang=\(requestUrl.lang)&limit=\(requestUrl.limit)&hours=\(requestUrl.hours)&extra=\(requestUrl.extra)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(requestUrl.key, forHTTPHeaderField: "X-Yandex-API-Key")
        
        return urlRequest
    }
}
