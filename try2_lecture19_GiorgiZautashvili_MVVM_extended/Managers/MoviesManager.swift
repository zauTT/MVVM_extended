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
