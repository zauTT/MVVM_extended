//
//  FavoritesViewModel.swift
//  lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//


import Foundation

class FavoritesViewModel {
    
    var favoriteMovies: [Movie] = [] {
        didSet {
            reloadTableView?()
        }
    }
    
    var onRemoveButtonTapped: ((Movie) -> Void)?
    
    var reloadTableView: (() -> Void)?
    
    func fetchFavoriteMovies() {
        favoriteMovies = FavoritesManager.shared.getAllFavorites()
    }
    
    func getMovie(at index: Int) -> Movie {
        return favoriteMovies[index]
    }
}
