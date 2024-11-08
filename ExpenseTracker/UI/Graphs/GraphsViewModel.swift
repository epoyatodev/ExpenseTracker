//
// GraphsViewModel.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import Foundation

@Observable
final class GraphsViewModel {
    private let transactionManager: TransactionProtocol
    var transactionsResults: [Transaction] = []
    var chartGroups: [ChartGroup] = []
    
    init(transactionManager: TransactionProtocol = TransactionManager()) {
        self.transactionManager = transactionManager
    }
    
    @MainActor
    func fetchTRansactions() {
        transactionManager.getTransactions(filterText: nil, category: nil, startDate: nil, endDate: nil) { transactions, error in
            if let transactions {
                self.transactionsResults = transactions
            } else {
                print(error ?? "")
            }
        }
    }
    
    @MainActor
    func createCharrtGroups() {
        Task.detached(priority: .high) {
            await self.fetchTRansactions()
            let calendar = Calendar.current
            let groupedByDate = Dictionary(grouping: self.transactionsResults) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                return components
            }
            
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue})
                let expense = dict.value.filter({ $0.category == Category.expense.rawValue})
                let savings = dict.value.filter({ $0.category == Category.savings.rawValue})
                
                let incomeTotalValue = income.reduce(0) { $0 + $1.amount }
                let expenseTotalValue = expense.reduce(0) { $0 + $1.amount }
                let savingsTotalValue = savings.reduce(0) { $0 + $1.amount }
                
                return ChartGroup(date: date,
                                  categories: [
                                    .init(totalValue: incomeTotalValue, category: .income),
                                    .init(totalValue: expenseTotalValue, category: .expense),
                                    .init(totalValue: savingsTotalValue, category: .savings)
                                  ],
                                  totalIncome: incomeTotalValue,
                                  totalExpense: expenseTotalValue,
                                  totalSavings: savingsTotalValue)
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
}
