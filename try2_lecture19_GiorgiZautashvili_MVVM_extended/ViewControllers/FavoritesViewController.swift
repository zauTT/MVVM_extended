//
//  FavoritesViewController.swift
//  lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//


import UIKit

class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoritesViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupLayout()
        viewModel.fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel.fetchFavorites() 
            tableView.reloadData()
        }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteMovieCell")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(showFavorites))
    }

    @objc private func showFavorites() {
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
}


extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieCell", for: indexPath)
        let movie = viewModel.favoriteMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
}
