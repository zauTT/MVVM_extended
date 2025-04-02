//
//  FavoritesManager.swift
//  lecture21_GiorgiZautashvili_UserDefaults
//
//  Created by Giorgi Zautashvili on 01.04.25.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favoriteMovies: [Movie] = []
    
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
            saveFavorites()
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.favoriteMovies)
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: UserDefaultKeys.favoriteMovies),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            favoriteMovies = decodedMovies
        }
    }
    
    func getAllFavorites() -> [Movie] {
        return favoriteMovies
    }
}
