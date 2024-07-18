//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import Foundation

class HomeViewModel {
    
    // key: Title Category e.g -> Movie / Tv
    // value: Data of Movies / Tvs
    private(set) var titles: [String: [Title]] = [:]
    
    var trendingMoviesCount: Int {
        return titles[String.trendingMovies]?.count ?? 0
    }
    
    var trendingTvsCount: Int {
        return titles[String.trendingTvs]?.count ?? 0
    }
    
    var popularMoviesCount: Int {
        return titles[String.popularMovies]?.count ?? 0
    }
    
    var upcomingMoviesCount: Int {
        return titles[String.upcomingMovies]?.count ?? 0
    }
    
    var topRatedMoviesCount: Int {
        return titles[String.topRatedMovies]?.count ?? 0
    }
    
    // MARK: - Fetch from API
    
    func getNowPlayingMovies(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .nowPlayingMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.trendingMovies, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    func getTrendingMovies(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .trendingMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.trendingMovies, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    func getTrendingTvs(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .trendingTvs, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.trendingTvs, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    func getPopularMovies(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .popularMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.popularMovies, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    func getUpcomingMovies(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .upcomingMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.upcomingMovies, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    func getTopRatedMovies(completion: (() -> Void)?, onError: (() -> Void)?) {
        let endpoint = Endpoint(path: .topRatedMovies, additionalPath: nil, query: nil, method: .GET)
        NetworkManager.shared.sendRequest(type: TitleResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleResponse):
                guard let self = self else { return }
                self.titles[String.topRatedMovies, default: []] = titleResponse.results
                completion?()
                
            case .failure(_):
                onError?()
            }
        }
    }
    
    // MARK: - Get fetched data
    
    func getNowPlayingMovies() -> [Title]? {
        guard let trendingMovies = titles[String.nowPlayingMovies] else {
            return nil
        }
        
        return trendingMovies
    }
    
    func getTrendingMovies() -> [Title]? {
        guard let trendingMovies = titles[String.trendingMovies] else {
            return nil
        }
        
        return trendingMovies
    }
    
    func getTrendingMovie(at index: Int) -> Title? {
        guard let trendingMovies = titles[String.trendingMovies], index < trendingMovies.count else {
            return nil
        }
        
        return trendingMovies[index]
    }
    
    func getTrendingTvs() -> [Title]? {
        guard let trendingTvs = titles[String.trendingTvs] else {
            return nil
        }
        
        return trendingTvs
    }
    
    func getTrendingTv(at index: Int) -> Title? {
        guard let trendingTvs = titles[String.trendingTvs], index < trendingTvs.count else {
            return nil
        }
        
        return trendingTvs[index]
    }
    
    func getPopularMovies() -> [Title]? {
        guard let popularMovies = titles[String.popularMovies] else {
            return nil
        }
        
        return popularMovies
    }
    
    func getPopularMovie(at index: Int) -> Title? {
        guard let popularMovies = titles[String.popularMovies], index < popularMovies.count else {
            return nil
        }
        
        return popularMovies[index]
    }
    
    func getUpcomingMovies() -> [Title]? {
        guard let upcomingMovies = titles[String.upcomingMovies] else {
            return nil
        }
        
        return upcomingMovies
    }
    
    func getUpcomingMovie(at index: Int) -> Title? {
        guard let upcomingMovies = titles[String.upcomingMovies], index < upcomingMovies.count else {
            return nil
        }
        
        return upcomingMovies[index]
    }
    
    func getTopRatedMovies() -> [Title]? {
        guard let topRatedMovies = titles[String.topRatedMovies] else {
            return nil
        }
        
        return topRatedMovies
    }
    
    func getTopRatedMovie(at index: Int) -> Title? {
        guard let topRatedMovies = titles[String.topRatedMovies], index < topRatedMovies.count else {
            return nil
        }
        
        return topRatedMovies[index]
    }
}

extension String {
    fileprivate static let nowPlayingMovies = "Now Playing Movies"
    fileprivate static let trendingMovies = "Trending Movies"
    fileprivate static let trendingTvs = "Trending Tvs"
    fileprivate static let popularMovies = "Popular Movies"
    fileprivate static let upcomingMovies = "Upcoming Movies"
    fileprivate static let topRatedMovies = "Top Rated Movies"
}
