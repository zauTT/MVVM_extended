//
//  MovieCellViewModel.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import UIKit

class MovieCellViewModel {
    
    let movie: Movie
    
    var titleText: String {
        return "Title: \(movie.title)"
    }
    
    var popularityText: String {
        return "Popularity: \(String(format: "%.2f", movie.popularity))"
    }
    
    var releaseDateText: String {
        return "Release Date: \(movie.releaseDate)"
    }
    
    var posterURL: String? {
        guard let path = movie.posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    init(movie: Movie) {
        self.movie = movie
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
