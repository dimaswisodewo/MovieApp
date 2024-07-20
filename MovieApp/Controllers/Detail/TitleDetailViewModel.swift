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
    
    init(title: Title, titleDetail: TitleDetail? = nil) {
        self.title = title
        self.titleDetail = titleDetail
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
    
    func likeTitle(_ title: Title, titleDetail: TitleDetail, poster: UIImage?, backdrop: UIImage?, completion: @escaping () -> Void) {
        DataPersistanceManager.shared.addTitleData(title, titleDetail, poster: poster, backdrop: backdrop) { result in
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
