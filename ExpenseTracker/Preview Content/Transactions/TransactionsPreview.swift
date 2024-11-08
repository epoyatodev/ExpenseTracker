//
// TransactionsPreview.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import Foundation

struct TransactionManagerTest: TransactionProtocol {
    
    func addTransaction(_ transaction: Transaction) {
        previewTransaction.append(transaction)
    }
    
    func getTransactions(filterText: String?, category: Category?, startDate: Date?, endDate: Date?, completion: @escaping([Transaction]?, String?) -> Void) {
        completion(previewTransaction, nil)
    }
    
    func removeTransaction(_ transaction: Transaction) {
        previewTransaction.removeAll(where: {$0.id == transaction.id})
    }
    
    func removeAllTransactions(_ transactions: [Transaction]) {
        previewTransaction.removeAll()
    }
    
    
}

var previewTransaction: [Transaction] = [
    .init(title: "Letra coche", remarks: "Automovil", amount: 165, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Café", remarks: "Café", amount: 2.30, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Salary", remarks: "Salary received!", amount: 3600, dateAdded: .now, category: .income, tintColor: tints.randomElement()!)
]


