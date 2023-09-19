//
//  Extension + Int.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 14.09.2023.
//

extension Int {
    func tempC() -> String {
        var temp = ""
        
        switch self {
        case 1...: temp = "+\(self)º"
        case ..<0: temp = "\(self)º"
        default: temp = "0º"
        }
        
        return temp
    }
    
    func tempF() -> String {
        var temp = ""
        let tempF = self * 9 / 5 + 32
        
        switch tempF {
        case 1...: temp = "+\(tempF)º"
        case ..<0: temp = "\(tempF)º"
        default: temp = "0º"
        }
        
        return temp
    }
}
