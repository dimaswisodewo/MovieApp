//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import Foundation

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    private init() {}
    
    @discardableResult
    func sendRequest<T: Codable>(type: T.Type, endpoint: Endpoint, header: [String: String]? = Constants.tmdbHeader, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: endpoint.getURL()) else {
            completion(.failure(APIError.failedToCreateURL))
#if DEBUG
            print(APIError.failedToCreateURL)
#endif
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = endpoint.getMethod
        request.allHTTPHeaderFields = header
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(APIError.failedToDecodeData))
#if DEBUG
            print(APIError.failedToDecodeData)
#endif
                }
            } else {
                completion(.failure(APIError.failedToFetchData))
#if DEBUG
                print(APIError.failedToFetchData)
#endif
            }
        }
        
        task.resume()
        
        return task
    }
}

enum APIError: Error {
    case failedToCreateURL
    case failedToFetchData
    case failedToDecodeData
    case failedToEncodeData
}

struct Endpoint {
    private let baseUrl: String
    private let path: EndpointPath?
    private let additionalPath: String?
    private let query: String?
    private let method: HttpMethod
    
    var getMethod: String {
        return method.rawValue
    }
    
    init(baseUrl: String = Constants.tmdbBaseURL, path: EndpointPath?, additionalPath: String?, query: String?, method: HttpMethod) {
        self.baseUrl = baseUrl
        self.path = path
        self.additionalPath = additionalPath
        self.query = query
        self.method = method
    }
    
    func getURL() -> String {
        var url = baseUrl
        if let unwrappedPath = path {
            url += unwrappedPath.rawValue
        }
        if let unwrappedAdditionalPath = additionalPath {
            url += unwrappedAdditionalPath
        }
        if let unwrappedQuery = query {
            url += "?\(unwrappedQuery)"
        }
        return url
    }
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

enum EndpointPath: String {
    case nowPlayingMovies = "movie/now_playing"
    case trendingMovies = "trending/movie/day"
    case trendingTvs = "trending/tv/day"
    case upcomingMovies = "movie/upcoming"
    case upcomingTvs = "tv/upcoming"
    case topRatedMovies = "movie/top_rated"
    case topRatedTvs = "tv/top_rated"
    case popularMovies = "movie/popular"
    case discoverMovies = "discover/movie"
    case searchMovies = "search/movie"
    case search = "search"
}
