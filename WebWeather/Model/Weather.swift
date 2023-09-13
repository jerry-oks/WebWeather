//
//  Weather.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import Foundation

enum Condition: String, Decodable {
    case clear = "clear"
    case partlyCloudy = "partly-cloudy"
    case cloudy = "cloudy"
    case overcast = "overcast"
    case drizzle = "drizzle"
    case lightRain = "light-rain"
    case rain = "rain"
    case moderateRain = "moderate-rain"
    case heavyRain = "heavy-rain"
    case continuousHeavyRain = "continuous-heavy-rain"
    case showers = "showers"
    case wetSnow = "wet-snow"
    case lightSnow = "light-snow"
    case snow = "snow"
    case snowShowers = "snow-showers"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case thunderstormWithRain = "thunderstorm-with-rain"
    case thunderstormWithHail = "thunderstorm-with-hail"
    
    var formatted: String {
        switch self {
        case .clear:
            return "ясно"
        case .partlyCloudy:
            return "переменно облачно"
        case .cloudy:
            return "облачно"
        case .overcast:
            return "пасмурно"
        case .drizzle:
            return "мелкий дождь"
        case .lightRain:
            return "легкий дождь"
        case .rain:
            return "дождь"
        case .moderateRain:
            return "умеренный дождь"
        case .heavyRain:
            return "сильный дождь"
        case .continuousHeavyRain:
            return "продолжительный сильный дождь"
        case .showers:
            return "ливень"
        case .wetSnow:
            return "мокрый снег"
        case .lightSnow:
            return "легкий снег"
        case .snow:
            return "снег"
        case .snowShowers:
            return "снегопад"
        case .hail:
            return "град"
        case .thunderstorm:
            return "гроза"
        case .thunderstormWithRain:
            return "дождь с грозой"
        case .thunderstormWithHail:
            return "град с грозой"
        }
    }
    
    var image: String {
        switch self {
        case .clear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy, .overcast:
            return "cloud.fill"
        case .drizzle, .lightRain:
            return "cloud.drizzle.fill"
        case .rain, .moderateRain:
            return "cloud.rain.fill"
        case .heavyRain, .continuousHeavyRain, .showers:
            return "cloud.heavyrain.fill"
        case .wetSnow, .lightSnow, .snow, .snowShowers:
            return "cloud.snow.fill"
        case .hail:
            return "cloud.hail.fill"
        case .thunderstorm:
            return "cloud.bolt.fill"
        case .thunderstormWithRain,.thunderstormWithHail:
            return "cloud.bolt.rain.fill"
        }
    }
}
    
struct Weather: Decodable {
    let now: Int
    let geoObject: GeoObject
    let fact: FactWeather
    let forecasts: [DayForecastWeather]
}

struct FactWeather: Decodable {
    let condition: Condition
    let temp: Int
    let feelsLike: Int
    let windSpeed: Double
    let windGust: Double
    let windDir: String
    let pressureMm: Int
    let humidity: Int
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
    let condition: Condition
    let tempAvg: Int
    let feelsLike: Int
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
            lang: "ru_RU",
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
