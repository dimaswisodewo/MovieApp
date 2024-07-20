//
//  DataPersistanceManager.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToAdd
    case failedToFetch
    case failedToUpdate
    case failedToDelete
}

// TODO: Nyimpen backdrop image + genres

class DataPersistanceManager {
    
    static let shared = DataPersistanceManager()
    
    private var isHasChanges = false
    
    private init() {}
    
    func getDatabaseLocation() -> [URL] {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    func isNeedToRefresh() -> Bool {
        return isHasChanges
    }
    
    func convertToTitleEntity(_ title: Title, titleDetail: TitleDetail, poster: UIImage?, backdrop: UIImage?, context: NSManagedObjectContext) -> TitleEntity {
        let entity = TitleEntity(context: context)
        entity.category = title.category.rawValue
        entity.id = Int32(title.id)
        entity.originalTitle = titleDetail.originalTitle ?? title.originalTitle
        entity.originalName = titleDetail.name ?? title.originalName
        entity.overview = title.overview
        entity.genre = titleDetail.genres.map({ $0.name }).joined(separator: ", ")
        entity.poster = poster?.jpegToBase64() ?? poster?.pngToBase64()
        entity.backdrop = backdrop?.jpegToBase64() ?? backdrop?.pngToBase64()
        entity.posterPath = title.posterPath
        entity.releaseDate = title.category == .movie ? title.releaseDate : titleDetail.lastAirDate
        entity.voteAverage = title.voteAverage ?? 0
        entity.voteCount = Int32(title.voteCount ?? 0)
        return entity
    }
    
    func isTitleExistsInDatabase(titleId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id = %@", titleId.description)
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            let fetchedData = try context.fetch(request)
            completion(.success(fetchedData.count > 0))
        } catch {
#if DEBUG
            print(DatabaseError.failedToFetch)
#endif
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    // Return list of tuples containing title data and image base64
    func fetchAllTitleData(completion: @escaping (Result<[(Title, String?, TitleDetail, String?)], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            let titles: [(Title, String?, TitleDetail, String?)] = entities.map { entity in
                let title = Title(
                    id: Int(entity.id),
                    mediaType: nil,
                    originalTitle: entity.originalTitle,
                    originalName: entity.originalName,
                    posterPath: entity.posterPath,
                    overview: entity.overview,
                    voteCount: Int(entity.voteCount),
                    releaseDate: entity.releaseDate,
                    voteAverage: entity.voteAverage
                )
                let titleDetail = TitleDetail(
                    backdropPath: nil,
                    genres: entity.genre?.components(separatedBy: ", ").map({ substring in
                        Genre(id: 0, name: substring.description)
                    }) ?? [],
                    homepage: "",
                    title: title.originalTitle,
                    name: title.originalName,
                    originalTitle: title.originalTitle,
                    overview: title.overview ?? "",
                    posterPath: title.posterPath,
                    releaseDate: entity.releaseDate,
                    lastAirDate: entity.releaseDate
                )
                let imageBase64: String? = entity.poster
                let backdropBase64: String? = entity.backdrop
                return (title, imageBase64, titleDetail, backdropBase64)
            }
            isHasChanges = false
            completion(.success(titles))
        } catch {
#if DEBUG
            print(DatabaseError.failedToFetch)
#endif
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    func addTitleData(_ title: Title, _ titleDetail: TitleDetail, poster: UIImage?, backdrop: UIImage?, completion: @escaping (Result<Title, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        _ = convertToTitleEntity(title, titleDetail: titleDetail, poster: poster, backdrop: backdrop, context: context)
        
        do {
            try context.save()
            isHasChanges = true
            completion(.success(title))
        } catch {
#if DEBUG
            print(DatabaseError.failedToAdd)
#endif
            completion(.failure(DatabaseError.failedToAdd))
        }
    }
    
    func updateTitleData(titleId: Int, newTitle: Title, newPoster: UIImage?, completion: @escaping (Result<Title, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id = %@", titleId.description)
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            guard let entity = try context.fetch(request).first else {
#if DEBUG
                print("There is not saved title with id: \(titleId)")
#endif
                throw DatabaseError.failedToUpdate
            }
            
            entity.category = newTitle.category.rawValue
            entity.id = Int32(newTitle.id)
            entity.originalName = newTitle.originalName
            entity.overview = newTitle.overview
            entity.poster = newPoster?.jpegToBase64() ?? newPoster?.pngToBase64()
            entity.posterPath = newTitle.posterPath
            entity.releaseDate = newTitle.releaseDate
            entity.voteAverage = newTitle.voteAverage ?? 0
            entity.voteCount = Int32(newTitle.voteCount ?? 0)
            
            try context.save()
            isHasChanges = true
            completion(.success(newTitle))
        } catch {
#if DEBUG
            print(DatabaseError.failedToUpdate)
#endif
            completion(.failure(DatabaseError.failedToUpdate))
        }
    }
    
    func deleteTitleData(titleId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id = %@", titleId.description)
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            guard let entity = try context.fetch(request).first else {
#if DEBUG
                print("There is not saved title with id: \(titleId)")
#endif
                throw DatabaseError.failedToUpdate
            }
            
            context.delete(entity)
            
            try context.save()
            isHasChanges = true
            completion(.success(()))
        } catch {
#if DEBUG
            print(DatabaseError.failedToDelete)
#endif
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
}
