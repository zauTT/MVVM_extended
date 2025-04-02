//
//  FavoritesViewController.swift
//  lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = FavoritesViewModel()
    var favoriteMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavorites()
        title = "Favorites"
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        tableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.systemYellow
        ]
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "FavoritesCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteMovies()
        loadFavorites()
    }
    
    private func loadFavorites() {
        favoriteMovies = FavoritesManager.shared.getAllFavorites()
        print("Favorites screen: \(favoriteMovies)")
        tableView.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onRemoveButtonTapped = { [weak self] movie in
            FavoritesManager.shared.removeFavorite(movie: movie)
            self?.loadFavorites()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesCell else {
            return UITableViewCell()
        }
        let movie = viewModel.getMovie(at: indexPath.row)
        cell.configure(with: movie)
        
        cell.onRemoveButtonTapped = { [weak self] in
            FavoritesManager.shared.removeFavorite(movie: movie)
            self?.viewModel.fetchFavoriteMovies()
            self?.loadFavorites()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.getMovie(at: indexPath.row)
        let detailViewModel = MovieDetailViewModel(movie: selectedMovie, movieID: selectedMovie.id)
        let detailVC = MovieDetailViewController(viewModel: detailViewModel, movie: selectedMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
