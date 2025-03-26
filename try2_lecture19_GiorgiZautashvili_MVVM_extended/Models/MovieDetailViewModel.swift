//
//  MovieDetailViewModel.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import UIKit

class MovieDetailViewModel {
    
    private let movie: Movie
    
    private let movieID: Int
    private let apiKey = "88a76539c103d283f84088bdc0534132"
    
    var titleText: String {
        return movie.title
    }
    
    var popularityText: String {
        return "Popularity: \(String(format: "%.2f", movie.popularity))"
    }
    
    var releaseDateText: String {
        return "Release Date: \(movie.releaseDate)"
    }
    
    var movieDescription: String = "Loading description..."
    
    var posterURL: String? {
        guard let path = movie.posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    init(movie: Movie, movieID: Int) {
        self.movie = movie
        self.movieID = movieID
    }
    
    func fetchMovieDetails(completion: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let movieDetails = try JSONDecoder().decode(MovieDetailsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movieDescription = movieDetails.overview
                        completion()
                    }
                } catch {
                    print("Error decoding movie details: \(error)")
                }
            }
        }.resume()
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let urlString = posterURL, let url = URL(string: urlString) else {
            completion(UIImage(named: "placeholderImage"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                completion(UIImage(named: "placeholderImage"))
            }
        }.resume()
    }
}

struct MovieDetailsResponse: Codable {
    let overview: String
}
