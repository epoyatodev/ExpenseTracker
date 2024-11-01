//
// Transaction.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct Transaction: Identifiable {
    let id: UUID = .init()
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting color value from tintColor String
    var color: Color {
        return tints.first(where: { $0.color == tintColor})?.value ?? .appTint
    }
}


var previewTransaction: [Transaction] = [
    .init(title: "Letra coche", remarks: "Automovil", amount: 165, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Café", remarks: "Café", amount: 2.30, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Salary", remarks: "Salary received!", amount: 3600, dateAdded: .now, category: .income, tintColor: tints.randomElement()!)
]
