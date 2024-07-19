//
//  Title.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import Foundation

enum Category {
    case movie
    case tv
}

struct TitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let mediaType: String?
    let originalTitle: String? // nil on tv
    let originalName: String? // nil on movie
    let posterPath: String?
    let overview: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double?
    
    var category: Category {
        return originalTitle == nil ? .tv : .movie
    }
    
    enum CodingKeys: String, CodingKey {
        case id, overview
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
