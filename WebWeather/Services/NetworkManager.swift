//
//  NetworkManager.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchWeather(from url: URLRequest, completion: @escaping (Result<Weather, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weather = try decoder.decode(Weather.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
                
                print("DATA:\n\(data)\n\nRESPONSE:\n\(String(describing: response))")
            } catch {
                completion(.failure(.decodingError))
                
                print("ERROR:\n\(error)")
            }
        }.resume()
    }
}
