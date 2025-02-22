//
//  LikedTitleViewModel.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit

class LikedTitleViewModel {
    
    private(set) var titlesWithPoster: [(Title, UIImage?, TitleDetail, UIImage?)] = []
    
    func fetchLikedTitles(completion: @escaping () -> Void) {
        DataPersistanceManager.shared.fetchAllTitleData { [weak self] result in
            switch result {
            case .success(let titles):
                let titlesWithPoster = titles.map { titleWithPoster in
                    let (title, poster, titleDetail, backdrop) = titleWithPoster
                    return (title, poster?.imageFromBase64(), titleDetail, backdrop?.imageFromBase64())
                }
                self?.titlesWithPoster = titlesWithPoster
                completion()
                
            case .failure(_):
                break
            }
        }
    }
}
