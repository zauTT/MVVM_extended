//
//  MovieCell.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    let posterView = UIImageView()
    let titleLabel = UILabel()
    let popularityLabel = UILabel()
    let releaseDateLabel = UILabel()
    
    private let addFavoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var movieCellViewModel: MovieCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addFavoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true
        posterView.layer.cornerRadius = 8
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        
        popularityLabel.translatesAutoresizingMaskIntoConstraints = false
        popularityLabel.font = UIFont.boldSystemFont(ofSize: 10)
        popularityLabel.textColor = .white
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.font = UIFont.systemFont(ofSize: 10)
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.textColor = .white
        
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(popularityLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(addFavoriteButton)
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            posterView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            popularityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            popularityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            
            releaseDateLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor, constant: 4),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            releaseDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
            
            addFavoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            addFavoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            addFavoriteButton.widthAnchor.constraint(equalToConstant: 40),
            addFavoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with viewModel: MovieCellViewModel) {
        self.movieCellViewModel = viewModel
        
        titleLabel.text = viewModel.titleText
        popularityLabel.text = viewModel.popularityText
        releaseDateLabel.text = viewModel.releaseDateText
        
        viewModel.loadImage { [weak self] image in
            self?.posterView.image = image
        }
        
        let isFavorite = FavoritesManager.shared.isFavorite(movie: viewModel.movie)
        let favoriteIconName = isFavorite ? "star.fill" : "star"
        addFavoriteButton.setImage(UIImage(systemName: favoriteIconName), for: .normal)
        
    }
    
    @objc private func addToFavorites() {
        guard let movie = movieCellViewModel?.movie else { return }
        if FavoritesManager.shared.isFavorite(movie: movie) {
            FavoritesManager.shared.removeFavorite(movie: movie)
            addFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            FavoritesManager.shared.addFavorite(movie: movie)
            addFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
}
