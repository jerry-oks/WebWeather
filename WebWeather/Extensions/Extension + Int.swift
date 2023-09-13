//
//  Extension + Int.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 14.09.2023.
//

extension Int {
    func temp() -> String {
        var temp = ""
        
        switch self {
        case 1...: temp = "+\(self)º"
        case ..<0: temp = "-\(self)º"
        default: temp = "0º"
        }
        
        return temp
    }
}
