//
// RecentsViewModel.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import Foundation

@Observable
final class RecentsViewModel {
    private let transactionManager: TransactionProtocol
    var transactions: [Transaction] = []
    
    init(transactionManager: TransactionProtocol = TransactionManager()) {
        self.transactionManager = transactionManager
    }
    
    @MainActor
    func saveTransaction(_ transaction: Transaction) {
        transactionManager.addTransaction(transaction)
        self.getTransactions(startDate: .now.startOnMonth, endDate: .now.endOnMonth)
    }
    
    @MainActor
    func removeTransaction(_ transaction: Transaction) {
        transactionManager.removeTransaction(transaction)
        self.getTransactions()
    }
    
    @MainActor
    func removeAllTransactions() {
        transactionManager.removeAllTransactions(self.transactions)
        self.getTransactions()
    }
    
    @MainActor
    func getTransactions(startDate: Date? = nil, endDate: Date? = nil) {
        transactionManager.getTransactions(filterText: nil, category: nil, startDate: startDate, endDate: endDate) { transactions, error in
            if let transactions {
                self.transactions = transactions
            } else {
                print(error ?? "")
            }
        }
    }
      
    func getExpenseAmount() -> Double {
        transactions.filter({$0.category == Category.expense.rawValue}).reduce(0) { $0 + $1.amount}
    }
    
    func getIncomeAmmount() -> Double {
        transactions.filter({$0.category == Category.income.rawValue}).reduce(0) { $0 + $1.amount}
    }
    
    func getSavingsAmmount() -> Double {
        transactions.filter({$0.category == Category.savings.rawValue}).reduce(0) { $0 + $1.amount}
    }
}
