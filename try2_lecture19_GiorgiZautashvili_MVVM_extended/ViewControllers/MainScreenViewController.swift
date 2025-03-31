//
//  MainScreenViewController.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//

import Foundation
import UIKit

class MainScreenViewController: UIViewController {
    
    private var viewModel = MainScreenViewModel()
    private var selectedMovie: Movie?
    private var isFavoritesView = false
    
    var favoriteMovies: [Movie] {
        return FavoritesManager.shared.getAllFavorites()
    }
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    let movieCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 300)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        
        viewModel = MainScreenViewModel()
        configureFavoriteButton()
        
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.movieCollection.reloadData()
            }
        }
        
        setupMovieCollection()
        bindViewModel()
        viewModel.fetchMovies()
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.movieCollection.reloadData()
            }
        }
    }
    
    func fetchMovies() {
        if isFavoritesView {
            viewModel.fetchFavoriteMovies()
        } else {
            viewModel.fetchMovies()
        }
    }
    
    private func configureFavoriteButton() {
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        if isFavoritesView {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @objc private func toggleFavorite() {
        
        print("Toggle Favorite Button Pressed")
        
        if let movie = selectedMovie {
            FavoritesManager.shared.addFavorite(movie: movie)
            shakeFavoritesButton()
        }
        isFavoritesView = true
        updateFavoriteButton()
        let favoritesVC = FavoritesViewController()
        favoritesVC.favoriteMovies = FavoritesManager.shared.getAllFavorites()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    private func setupMovieCollection() {
        view.addSubview(movieCollection)
        movieCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieCollection.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 10),
            movieCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            movieCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        movieCollection.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 45/255, alpha: 1)
        movieCollection.delegate = self
        movieCollection.dataSource = self
        movieCollection.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
    
    private func shakeFavoritesButton() {
        favoriteButton.isUserInteractionEnabled = false
        
        favoriteButton.layer.removeAnimation(forKey: "shake")
        
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shakeAnimation.values = [-10, 10, -8, 8, -5, 5, 0]
        shakeAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1, 1]
        shakeAnimation.duration = 0.5
        
        favoriteButton.layer.add(shakeAnimation, forKey: "shake")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.favoriteButton.isUserInteractionEnabled = true
        }
    }
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFavoritesView ? viewModel.favoriteMoviesArray.count : viewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movie = viewModel.getMovie(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieCellViewModel = MovieCellViewModel(movie: movie)
        cell.configure(with: movieCellViewModel)
        
        cell.favoriteButtonTapped = { [weak self] in
            self?.shakeFavoritesButton()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedMovie = viewModel.getMovie(at: indexPath.row) {
            self.selectedMovie = selectedMovie
            let detailViewModel = MovieDetailViewModel(movie: selectedMovie, movieID: selectedMovie.id)
            let detailVC = MovieDetailViewController(viewModel: detailViewModel, movie: selectedMovie)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
