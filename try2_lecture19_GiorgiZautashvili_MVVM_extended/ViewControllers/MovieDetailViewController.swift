//
//  MovieDetailViewController.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import UIKit

class MovieDetailViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModel?
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
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
    }
    
    private func setupUI() {
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(popularityLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 250),
            posterImageView.heightAnchor.constraint(equalToConstant: 375),
            
            popularityLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            popularityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor, constant: 10),
            releaseDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
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
    }
}
