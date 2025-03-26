//
//  FavoritesManager.swift
//  lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//

import Foundation


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
        favoriteMovies.removeAll { $0.id == movie.id }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encodedData, forKey: self.favoritesKey)
            print("Favorites saved: \(favoriteMovies)")
        } else {
            print("Failed to encode favorite movies")
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: self.favoritesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            favoriteMovies = decodedMovies
            print("Favorites loaded: \(favoriteMovies)")
        } else {
            print("Failed to load favorite movies or no data found")
        }
    }
    
    func getAllFavorites() -> [Movie] {
        return favoriteMovies
    }
}
