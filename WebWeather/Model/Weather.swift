//
//  Weather.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import Foundation

enum Condition: String {
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
            return "ясно       "
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
            return "ливень"
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
            return "cloud.sun.bolt.fill"
        case .thunderstormWithRain,.thunderstormWithHail:
            return "cloud.bolt.rain.fill"
        }
    }
    
    var nightImage: String {
        switch self {
        case .clear:
            return "moon.stars.fill"
        case .partlyCloudy:
            return "cloud.moon.fill"
        case .cloudy, .overcast:
            return "cloud.fill"
        case .drizzle, .lightRain:
            return "cloud.moon.rain.fill"
        case .rain, .moderateRain:
            return "cloud.rain.fill"
        case .heavyRain, .continuousHeavyRain, .showers:
            return "cloud.heavyrain.fill"
        case .wetSnow, .lightSnow, .snow, .snowShowers:
            return "cloud.snow.fill"
        case .hail:
            return "cloud.hail.fill"
        case .thunderstorm:
            return "cloud.moon.bolt.fill"
        case .thunderstormWithRain,.thunderstormWithHail:
            return "cloud.bolt.rain.fill"
        }
    }
}

enum WindDir: String {
    case nw = "nw"
    case n = "n"
    case ne = "ne"
    case e = "e"
    case se = "se"
    case s = "s"
    case sw = "sw"
    case w = "w"
    case c = "c"
    
    var formatted: String {
        switch self {
        case .nw:
            return "↘︎ СЗ"
        case .n:
            return "↓ С"
        case .ne:
            return "↙︎ СВ"
        case .e:
            return "← В"
        case .se:
            return "↖︎ ЮВ"
        case .s:
            return "↑ Ю"
        case .sw:
            return "↗︎ ЮЗ"
        case .w:
            return "→ З"
        case .c:
            return "штиль"
        }
    }
}

struct Weather {
    let geoObject: GeoObject
    let fact: FactWeather
    let forecasts: [DayForecastWeather]
    
    init(weatherData: [String: Any]) {
        geoObject = GeoObject(
            geoObject: weatherData["geo_object"] as? [String: Any] ?? [:]
        )
        fact = FactWeather(
            factWeather: weatherData["fact"] as? [String: Any] ?? [:]
        )
        forecasts = getForecasts()
        
        func getForecasts() -> [DayForecastWeather] {
            var forecasts: [DayForecastWeather] = []
            
            let forecastsData = weatherData["forecasts"] as? [[String: Any]] ?? []
            forecastsData.forEach { forecast in
                forecasts.append(DayForecastWeather(dayForecastWeather: forecast))
            }
            
            return forecasts
        }
    }
    
    static func getWeather(from json: Any) -> Weather {
        let weatherData = json as? [String: Any]
        return Weather(weatherData: weatherData!)
    }
}

struct FactWeather {
    let condition: Condition
    let temp: Int
    let daytime: String
    let feelsLike: Int
    let windSpeed: Double
    let windGust: Double
    let windDir: WindDir
    let pressureMm: Double
    let humidity: Int
    
    init(factWeather: [String: Any]) {
        condition = Condition(
            rawValue: factWeather["condition"] as? String ?? ""
        ) ?? .clear
        temp = factWeather["temp"] as? Int ?? 0
        daytime = factWeather["daytime"] as? String ?? ""
        feelsLike = factWeather["feels_like"] as? Int ?? 0
        windSpeed = factWeather["wind_speed"] as? Double ?? 0
        windGust = factWeather["wind_gust"] as? Double ?? 0
        windDir = WindDir(
            rawValue: factWeather["wind_dir"] as? String ?? ""
        ) ?? .c
        pressureMm = factWeather["pressure_mm"] as? Double ?? 0
        humidity = factWeather["humidity"] as? Int ?? 0
    }
}

struct GeoObject {
    let locality: GeoObjectName
    
    init(geoObject: [String: Any]) {
        locality = GeoObjectName(
            geoObjectName: geoObject["locality"] as? [String : Any] ?? [:]
        )
    }
    
}

struct GeoObjectName {
    let name: String
    
    init(geoObjectName: [String: Any]) {
        name = geoObjectName["name"] as? String ?? ""
    }
}

struct DayForecastWeather {
    let date: String
    let parts: PartOfTheDayWeather
    
    init(dayForecastWeather: [String: Any]) {
        date = dayForecastWeather["date"] as? String ?? ""
        parts = PartOfTheDayWeather(
            partOfTheDayWeather: dayForecastWeather["parts"] as? [String: Any] ?? [:]
        )
    }
}

struct PartOfTheDayWeather {
    let night: WeatherCondition
    let morning: WeatherCondition
    let day: WeatherCondition
    let evening: WeatherCondition
    
    init(partOfTheDayWeather: [String: Any]) {
        night = WeatherCondition(
            weatherCondition: partOfTheDayWeather["night"] as? [String : Any] ?? [:]
        )
        morning = WeatherCondition(
            weatherCondition: partOfTheDayWeather["morning"] as? [String : Any] ?? [:]
        )
        day = WeatherCondition(
            weatherCondition: partOfTheDayWeather["day"] as? [String : Any] ?? [:]
        )
        evening = WeatherCondition(
            weatherCondition: partOfTheDayWeather["evening"] as? [String : Any] ?? [:]
        )
    }
}

struct WeatherCondition {
    let condition: Condition
    let tempAvg: Int
    let feelsLike: Int
    
    init(weatherCondition: [String: Any]) {
        condition = Condition(
            rawValue: weatherCondition["condition"] as? String ?? ""
        ) ?? .clear
        tempAvg = weatherCondition["temp_avg"] as? Int ?? 0
        feelsLike = weatherCondition["feels_like"] as? Int ?? 0
    }
}

struct RequestURL {
    let lat: String
    let lon: String
    let lang: String
    let limit: String
    let hours: String
    let extra: String
    let key: String
    
    static func getURL(lat: String, lon: String) -> URLRequest {
        let requestUrl = RequestURL(
            lat: lat,
            lon: lon,
            lang: "ru_RU",
            limit: "7",
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
