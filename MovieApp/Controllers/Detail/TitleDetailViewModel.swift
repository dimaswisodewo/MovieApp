//
//  TitleDetailViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import Foundation

class TitleDetailViewModel {
    
    let title: Title
    private(set) var titleDetail: TitleDetail?
    
    private(set) var ongoingTask: URLSessionDataTask?
    
    init(title: Title) {
        self.title = title
    }
    
    func getMovieDetail(completion: @escaping (TitleDetail) -> Void) {
        let endpoint = Endpoint(
            path: title.category == .movie ? .movie : .tv,
            additionalPath: "/\(title.id.description)",
            query: nil,
            method: .GET
        )
        
        ongoingTask = NetworkManager.shared.sendRequest(type: TitleDetail.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let titleDetail):
                self?.titleDetail = titleDetail
                completion(titleDetail)
                
            case .failure(_):
                break
            }
            
            self?.ongoingTask = nil
        }
    }
}
