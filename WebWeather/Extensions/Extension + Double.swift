//
//  Extension + Double.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 18.09.2023.
//

import Foundation

extension Double {
    func mbar() -> String {
        let string = String(format: "%.2f", self * 1.333)
        
        return "\(string) мбар"
    }
    
    func inHg() -> String {
        let string = String(format: "%.2f", self / 25.4)
        
        return "\(string) д. рт. ст."
    }
    
    func mmHg() -> String {
        "\(Int(self)) мм рт. ст."
    }
    
    func hPa() -> String {
        let string = String(format: "%.2f", self * 1.333)
        
        return "\(string) гПа"
    }
    
    func kPa() -> String {
        let string = String(format: "%.2f", self / 7.501)

        return "\(string) кПа"
    }
    
    
    func mph() -> String {
        let string = String(format: "%.2f", self * 2.237)
        
        return "\(string) ми/ч"
    }
    
    func kmh() -> String {
        let string = String(format: "%.2f", self * 3.6)
        
        return "\(string) км/ч"
    }
    
    func ms() -> String {
        "\(self) м/с"
    }
    
    func bft() -> String {
        var bft = ""
        
        switch self {
        case ..<0.3:
            bft = "0 баллов"
        case 0.3...1.5:
            bft = "1 балл"
        case 1.5..<3.3:
            bft = "2 балла"
        case 3.3..<5.4:
            bft = "3 балла"
        case 5.4..<7.9:
            bft = "4 балла"
        case 7.9..<10.7:
            bft = "5 баллов"
        case 10.7..<13.8:
            bft = "6 баллов"
        case 13.8..<17.1:
            bft = "7 баллов"
        case 17.1..<20.7:
            bft = "8 баллов"
        case 20.7..<24.4:
            bft = "9 баллов"
        case 24.4..<28.4:
            bft = "10 баллов"
        case 28.4..<32.6:
            bft = "11 баллов"
        default:
            bft = "12 баллов"
        }
        
        return "\(bft) по Бофорту"
    }
    
    func kn() -> String {
        let string = String(format: "%.2f", self * 1.944)

        return "\(string) уз"
    }
}
