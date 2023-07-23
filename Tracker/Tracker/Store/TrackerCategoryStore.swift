//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Konstantin Zuykov on 14.07.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    
    var categories = [TrackerCategory]()
    
    private let context: NSManagedObjectContext
    
    // MARK: - Lifecycle
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Сouldn't get app AppDelegate")
        }

        let context = appDelegate.persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        try setupCategories(with: context)
    }
    
    // MARK: - Methods
    
    func categoryCoreData(with id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category: [TrackerCategoryCoreData]
        do {
            category = try context.fetch(request)
        } catch {
            throw StoreError.fetchError
        }
        if(category.isEmpty) {
            return TrackerCategoryCoreData()
        }
        return category[0]
    }
    
    private func makeCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard
            let idString = coreData.categoryId,
            let id = UUID(uuidString: idString),
            let label = coreData.label
        else { throw StoreError.decodeError }
        return TrackerCategory(id: id,label: label)
    }
    
    private func setupCategories(with context: NSManagedObjectContext) throws {
        let checkRequest = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(checkRequest)
        
        guard result.count == 0 else {
            categories = try result.map({ try makeCategory(from: $0) })
            return
        }
    
        let _ = [
            TrackerCategory(label: "Домашний уют"),
            TrackerCategory(label: "Радостные мелочи")
        ].map { category in
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.categoryId = category.id.uuidString
            categoryCoreData.createdAt = Date()
            categoryCoreData.label = category.label
            return categoryCoreData
        }
        
        try context.save()
    }
}

// MARK: - Layout methods

extension TrackerCategoryStore {
    enum StoreError: Error {
        case decodeError
        case fetchError
    }
}

