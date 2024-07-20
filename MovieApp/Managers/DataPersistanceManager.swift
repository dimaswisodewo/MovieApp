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

class DataPersistanceManager {
    
    static let shared = DataPersistanceManager()
    
    private init() {}
    
    func getDatabaseLocation() -> [URL] {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    func convertToTitleEntity(_ title: Title, poster: UIImage?, context: NSManagedObjectContext) -> TitleEntity {
        let entity = TitleEntity(context: context)
        entity.category = title.category.rawValue
        entity.id = Int32(title.id)
        entity.originalName = title.originalName
        entity.overview = title.overview
        entity.poster = poster?.jpegToBase64() ?? poster?.pngToBase64()
        entity.posterPath = title.posterPath
        entity.releaseDate = title.releaseDate
        entity.voteAverage = title.voteAverage ?? 0
        entity.voteCount = Int32(title.voteCount ?? 0)
        return entity
    }
    
    // Return list of tuples containing title data and image base64
    func fetchAllTitleData(completion: @escaping (Result<[(Title, String?)], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            let titles: [(Title, String?)] = entities.map { entity in
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
                let imageBase64: String? = entity.poster
                return (title, imageBase64)
            }
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    func addTitleData(_ title: Title, poster: UIImage?, completion: @escaping (Result<Title, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = convertToTitleEntity(title, poster: poster, context: context)
        
        do {
            try context.save()
            completion(.success(title))
        } catch {
            completion(.failure(DatabaseError.failedToAdd))
        }
    }
    
    func updateTitleData(titleId: Int, newTitle: Title, newPoster: UIImage?, completion: @escaping (Result<Title, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id = %@", titleId)
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            guard let entity = try context.fetch(request).first else {
                print("There is not saved title with id: \(titleId)")
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
            completion(.success(newTitle))
        } catch {
            completion(.failure(DatabaseError.failedToUpdate))
        }
    }
    
    func deleteTitleData(titleId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id = %@", titleId)
        
        let request: NSFetchRequest<TitleEntity>
        request = TitleEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            guard let entity = try context.fetch(request).first else {
                print("There is not saved title with id: \(titleId)")
                throw DatabaseError.failedToUpdate
            }
            
            context.delete(entity)
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToUpdate))
        }
    }
}
