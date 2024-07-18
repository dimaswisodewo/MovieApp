//
//  SearchResponse.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import Foundation

struct SearchResponse: Codable {
    let page: Int
    let results: [Title]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
