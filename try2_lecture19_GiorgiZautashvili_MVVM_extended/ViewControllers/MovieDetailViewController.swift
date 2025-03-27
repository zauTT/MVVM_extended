//
//  MovieDetailViewController.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import UIKit

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModel?
    var favoriteMovie: [Movie] = []
    private var movie: Movie
    
    init(viewModel: MovieDetailViewModel, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    let popularityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        
        setupUI()
        configureUI()
        
        viewModel?.fetchMovieDetails {
            DispatchQueue.main.async { [weak self] in
                self?.descriptionLabel.text = "Movie description: \(self?.viewModel?.movieDescription ?? "No description available")"
            }
        }
        
        favoriteButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(popularityLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 250),
            posterImageView.heightAnchor.constraint(equalToConstant: 375),
            
            favoriteButton.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -10),
            favoriteButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10),
            
            popularityLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            popularityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor, constant: 10),
            releaseDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func favoritesButtonTapped() {
        guard viewModel != nil else { return }
        
        if FavoritesManager.shared.isFavorite(movie: movie) {
            FavoritesManager.shared.removeFavorite(movie: movie)
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            FavoritesManager.shared.addFavorite(movie: movie)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    private func configureUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        titleLabel.text = viewModel.titleText
        popularityLabel.text = viewModel.popularityText
        releaseDateLabel.text = viewModel.releaseDateText
        
        if viewModel.posterURL != nil {
            viewModel.loadImage { [weak self] image in
                DispatchQueue.main.async {
                    self?.posterImageView.image = image ?? UIImage(named: "placeholderImage")
                }
            }
        }
        
        let starImage = FavoritesManager.shared.isFavorite(movie: movie) ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: starImage), for: .normal)
    }
}
