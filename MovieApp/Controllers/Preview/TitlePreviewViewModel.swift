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
        
        ongoingTask = NetworkManager.shared.sendRequest(type: YoutubeResponse.self, endpoint: endpoint, header: nil) { [weak self] result in
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
