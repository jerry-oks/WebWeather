//
//  NetworkManager.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchWeather(from url: URLRequest, completion: @escaping (Result<Weather, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let jsonValue):
                    let weather = Weather.getWeather(from: jsonValue)
                    completion(.success(weather))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
