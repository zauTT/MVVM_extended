//
//  NetworkManager.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//

import Foundation

enum NetworkError: Error {
    case wrongResponse
    case statusCodeError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getData<T: Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> (Void)) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Wrong Response")
                completion(.failure(NetworkError.wrongResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("Wrong Response code: \(response.statusCode)")
                completion(.failure(NetworkError.statusCodeError))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
