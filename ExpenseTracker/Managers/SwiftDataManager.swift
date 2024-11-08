//
//  SwiftDataManager.swift
//  RickAndMortyApp
//
//  Created by Enrique Poyato Ortiz on 16/10/24.
//

import Foundation
import SwiftData

final class SwiftDataManager {
    static let shared: SwiftDataManager = .init()
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: Transaction.self, User.self)
        } catch {
            fatalError("Error initializing ModelContainer: \(error)")
        }
    }
    
    @MainActor
    var modelContext: ModelContext {
        container.mainContext
    }
    
    @MainActor
    func fetchOne<T: PersistentModel>(model: T.Type, filter: Predicate<T>? = nil, sortBy: [SortDescriptor<T>]? = nil, completion: @escaping(T?, String?) -> Void)  {
        let fetchDescriptor = FetchDescriptor<T>(predicate: filter, sortBy: sortBy ?? [])
        
        do {
            if let result = try modelContext.fetch(fetchDescriptor).first {
                completion(result, nil)
            } else {
                completion(nil, "❌ Fav not found!")
            }
        } catch {
            completion(nil, error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchAll<T: PersistentModel>(model: T.Type, filter: Predicate<T>? = nil, sortBy: [SortDescriptor<T>]? = nil, completion: @escaping(Result<[T], Error>) -> Void)  {
        let fetchDescriptor = FetchDescriptor<T>(predicate: filter, sortBy: sortBy ?? [])
        
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            completion(.success(results))
        } catch {
            completion(.failure(error))
        }
    }
    
    @MainActor
    func delete<T: PersistentModel>(model: T) {
        modelContext.delete(model)
        try? modelContext.save()
    }
    
    @MainActor
    func deleteAll<T: PersistentModel>(models: [T]) {
        models.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }
    
    @MainActor
    func insert<T: PersistentModel>(model: T) {
        modelContext.insert(model)
        try? modelContext.save()
    }
}
