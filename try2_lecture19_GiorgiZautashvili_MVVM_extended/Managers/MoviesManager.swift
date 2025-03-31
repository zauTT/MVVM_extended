//
//  MoviesManager.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import Foundation

class MoviesManager {
    static let shared = MoviesManager()
    
    private init() {}
    
    func getMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let apiKey = "88a76539c103d283f84088bdc0534132"
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        
        NetworkManager.shared.getData(urlString: urlString) { (result: Result <MovieResponse, Error>) in
            switch result {
            case .success(let response):
                if response.results.isEmpty {
                    print("No movies found.")
                    completion(.success([]))
                } else {
                    completion(.success(response.results))
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favoriteMovies: [Movie] = []
    private let favoritesKey = "favoriteMoviesKey"
    
    private init() {
        loadFavorites()
    }
    
    func addFavorite(movie: Movie) {
        guard !favoriteMovies.contains(where: { $0.id == movie.id }) else { return }
        favoriteMovies.append(movie)
        saveFavorites()
    }
    
    func removeFavorite(movie: Movie) {
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: index)
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encodedData, forKey: self.favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: self.favoritesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            favoriteMovies = decodedMovies
        }
    }
    
    func getAllFavorites() -> [Movie] {
        return favoriteMovies
    }
}

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


