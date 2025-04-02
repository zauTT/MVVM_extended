//
//  MainScreenViewModel.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//

import Foundation

class MainScreenViewModel {
    
    private var moviesArray: [Movie] = []
    var favoriteMoviesArray: [Movie] = []
    private let favoritesManager = FavoritesManager.shared
    
    var reloadCollectionView: (() -> Void)?
    var onMoviesUpdated: (() -> Void)?
    
    var numberOfMovies: Int {
        return moviesArray.count
    }
    
    var isFavoritesView = false
    
    func addMoviesToFavorites(_ movie: Movie) {
        favoritesManager.addFavorite(movie: movie)
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoritesManager.getAllFavorites().contains(where: { $0.id == movie.id })
    }
    
    func fetchFavoriteMovies() {
        favoriteMoviesArray = favoritesManager.getAllFavorites()
        reloadCollectionView?()
    }
    
    func fetchMovies() {
        MoviesManager.shared.getMovies(page: 2) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.moviesArray = movies
                self?.onMoviesUpdated?()
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
    
    func getMovie(at index: Int) -> Movie? {
        if isFavoritesView {
            
            guard index >= 0 && index < favoriteMoviesArray.count else { return nil }
            return favoriteMoviesArray[index]
        } else {
            guard index >= 0 && index < moviesArray.count else { return nil }
            return moviesArray[index]
        }
    }
    
    func toggleFavoritesView() {
        isFavoritesView.toggle()
        if isFavoritesView {
            fetchFavoriteMovies()
        } else {
            fetchMovies()
        }
    }
}
