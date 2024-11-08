//
// Transaction.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import SwiftData

@Model
class Transaction: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    init(id: UUID = .init(), title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.id = id
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


extension Transaction {
    static var emptyTransaction: Transaction {
        .init(id: .init(), title: "", remarks: "", amount: 0, dateAdded: .distantPast, category: .income, tintColor: TintColor(color: "Blue", value: .appTint))
    }
}
