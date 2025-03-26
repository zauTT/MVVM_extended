//
//  FavoritesCell.swift
//  try2_lecture19_GiorgiZautashvili_MVVM_extended
//
//  Created by Giorgi Zautashvili on 25.03.25.
//


import UIKit

class FavoritesCell: UITableViewCell {
    
    private let movieTitleLabel = UILabel()
    private let moviePosterImageView = UIImageView()
    private let removeButton = UIButton(type: .system)
    private var movie: Movie? 
    
    var onRemoveButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellUI() {
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 60/255, alpha: 1)
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.textColor = .lightGray
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        moviePosterImageView.contentMode = .scaleAspectFit
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.cornerRadius = 8
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        removeButton.tintColor = .red
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            moviePosterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 60),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 90),
            
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            movieTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    @objc func removeButtonTapped() {
        onRemoveButtonTapped?()
    }
    // for github commit
    func configure(with movie: Movie) {
        self.movie = movie
        movieTitleLabel.text = movie.title
        
        if let posterPath = movie.posterPath, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            loadImage(from: imageUrl)
        } else {
            moviePosterImageView.image = UIImage(named: "default_poster")
        }
        
        onRemoveButtonTapped = { [weak self] in
            self?.onRemoveButtonTapped?()
        }
        
    }
    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.moviePosterImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.moviePosterImageView.image = UIImage(named: "default_poster")
                }
            }
        }
    }
}
