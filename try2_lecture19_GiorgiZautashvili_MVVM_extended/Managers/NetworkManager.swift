//
//  NetworkManager.swift
//  lecture21_GiorgiZautashvili_UserDefaults
//
//  Created by Giorgi Zautashvili on 01.04.25.
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
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.wrongResponse))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
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
