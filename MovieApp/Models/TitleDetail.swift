//
//  TitleDetail.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import Foundation

struct TitleDetail: Codable {
    let backdropPath: String?
    let genres: [Genre]
    let homepage: String
    let title: String?
    let name: String?
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let lastAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case genres, homepage, title, name, overview
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case lastAirDate = "last_air_date"
    }
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
