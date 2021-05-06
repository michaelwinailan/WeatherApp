//
//  OpenWeatherHelper.swift
//  WeatherApp
//
//  Created by Michael Winailan on 4/22/21.
//

import Foundation

public class OpenWeatherHelper {
    
    public static let shared = OpenWeatherHelper()
    
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    public func parseJSON<T: Decodable>(urlString: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, completion: @escaping (Result<T,APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error(NSLocalizedString("Error: URL is invalid.", comment: ""))))
            return
        }
        
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.error(NSLocalizedString("Error: Corrupted Data.", comment: ""))))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
            jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
            
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completion(.success(decodedData))
                return
            } catch let decodingError {
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                return
            }
            
        }.resume()
    }
}
