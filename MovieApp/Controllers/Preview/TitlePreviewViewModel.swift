//
//  TitlePreviewViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import Foundation

class TitlePreviewViewModel {
    
    private(set) var ongoingTask: URLSessionDataTask?
    
    func getSearchYoutubeVideos(query: String, completion: @escaping (String) -> Void) {
        let headers: [String: String] = [
            "X-Ios-Bundle-Identifier": "com.dimaswisodewo.MovieApp"
        ]
        
        let queries: [String: Any] = [
            "q": "\(query) trailer",
            "key": Constants.YouTube_API_KEY,
            "maxResults": 1
        ]
        
        let encodedQuery = queries.map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let endpoint = Endpoint(
            baseUrl: Constants.Youtube_BaseURL,
            path: .search,
            additionalPath: nil,
            query: encodedQuery,
            method: .GET
        )
        
        // Youtube Data API 3 give 10000 token limitation per day, searching cost 100 token per API call. When exceed limit, will return 403
        ongoingTask = NetworkManager.shared.sendRequest(type: YoutubeResponse.self, endpoint: endpoint, header: headers) { [weak self] result in
            switch result {
            case .success(let youtubeResponse):
                guard let videoId = youtubeResponse.items.first?.id.videoId else { return }
                completion(videoId)
                break
                
            case .failure(_):
                break
            }
            
            self?.ongoingTask = nil
        }
    }
}
