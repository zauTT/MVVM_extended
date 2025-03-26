//
//  MovieResponse.swift
//  lecture18_GiorgiZautashvili_ARcPatterns
//
//  Created by Giorgi Zautashvili on 22.03.25.
//


import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Codable {
    let posterPath: String?
    let releaseDate: String
    let id: Int
    let title: String
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case id
        case title
        case popularity
    }
}