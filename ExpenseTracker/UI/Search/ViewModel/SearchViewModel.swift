//
// SearchViewModel.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

@Observable
final class SearchViewModel {
    private let transactionManager: TransactionProtocol
    var transactionsResults: [Transaction] = []
    
    init(transactionManager: TransactionProtocol = TransactionManager()) {
        self.transactionManager = transactionManager
    }
    
    @MainActor
    func search(category: Category?, filterText: String) {
        transactionManager.getTransactions(filterText: filterText, category: category, startDate: nil, endDate: nil) { transactions, error in
            if let transactions {
                DispatchQueue.main.async{
                    self.transactionsResults = transactions
                }
            } else {
                print(error ?? "")
            }
        }
    }
}
