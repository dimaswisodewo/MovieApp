//
//  TitleDetailViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import UIKit

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
    
    func likeTitle(_ title: Title, poster: UIImage?, completion: @escaping () -> Void) {
        DataPersistanceManager.shared.addTitleData(title, poster: poster) { result in
            switch result {
            case .success(_):
                completion()
                
            case .failure(_):
                break
            }
        }
    }
    
    func unlikeTitle(titleId: Int, completion: @escaping () -> Void) {
        DataPersistanceManager.shared.deleteTitleData(titleId: titleId) { result in
            switch result {
            case .success(_):
                completion()
                
            case .failure(_):
                break
            }
        }
    }
    
    func isTitleLiked(titleId: Int, completion: @escaping (Bool) -> Void) {
        DataPersistanceManager.shared.isTitleExistsInDatabase(titleId: titleId) { result in
            switch result {
            case .success(let isExists):
                completion(isExists)
                
            case .failure(_):
                break
            }
        }
    }
}
