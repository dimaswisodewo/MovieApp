//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import Foundation

class SearchViewModel {
    
    private(set) var titles: [Title] = []
    
    private(set) var lastSearchResults: [Title] = []
    private(set) var ongoingTask: URLSessionDataTask?
    
    func getDiscoverMovies(completion: @escaping () -> Void) {
        let endpoint = Endpoint(path: .discoverMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let response):
                self?.titles = response.results
                completion()
                
            case .failure(_):
                break
            }
        }
    }
    
    func getSearchCollection(query: String, completion: @escaping ([Title]) -> Void) {
        
        let queries: [String: Any] = [
            "query": query,
            "page": 1
        ]
        
        let finalQuery = queries.map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
        
        let endpoint = Endpoint(path: .searchCollection, additionalPath: nil, query: finalQuery, method: .GET)
        
        ongoingTask = NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let response):
                self?.lastSearchResults = response.results
                completion(response.results)
                
            case .failure(_):
                break
            }
            
            self?.ongoingTask = nil
        }
    }
}
