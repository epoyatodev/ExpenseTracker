//
// Transactionmanager.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import Foundation


protocol TransactionProtocol {
    @MainActor func addTransaction(_ transaction: Transaction)
    @MainActor func getTransactions(filterText: String?, category: Category?, startDate: Date?, endDate: Date?, completion: @escaping([Transaction]?, String?) -> Void)
    @MainActor func removeTransaction(_ transaction: Transaction)
    @MainActor func removeAllTransactions(_ transactions: [Transaction])
}


struct TransactionManager: TransactionProtocol {
    private let swiftDataManager: SwiftDataManager = .shared
    
    @MainActor
    func addTransaction(_ transaction: Transaction) {
        swiftDataManager.insert(model: transaction)
    }
    
    @MainActor
    func getTransactions(filterText: String?, category: Category?, startDate: Date?, endDate: Date?, completion: @escaping([Transaction]?, String?) -> Void) {
        var predicate: Predicate<Transaction>?
        let rawValue = category?.rawValue ?? ""

        if let startDate, let endDate {
            predicate = #Predicate<Transaction> {
                return $0.dateAdded >= startDate && $0.dateAdded <= endDate
            }
        }
        
        if let filterText {
            predicate = #Predicate<Transaction> {
                return ($0.title.localizedStandardContains(filterText) || $0.remarks.localizedStandardContains(filterText)) && (rawValue.isEmpty ? true : $0.category == rawValue)
            }
        }
        
        let sortByDate: [SortDescriptor] = [SortDescriptor(\Transaction.dateAdded, order: .reverse)]
        
        swiftDataManager.fetchAll(model: Transaction.self, filter: predicate, sortBy: sortByDate) { result in
            switch result {
            case .success(let transactions):
                completion(transactions, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }

    }
    
    @MainActor
    func removeTransaction(_ transaction: Transaction) {
        swiftDataManager.delete(model: transaction)
    }
    
    @MainActor
    func removeAllTransactions(_ transactions: [Transaction]) {
        swiftDataManager.deleteAll(models: transactions)
    }
}
