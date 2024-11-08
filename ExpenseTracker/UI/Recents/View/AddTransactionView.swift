//
// AddTransactionView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct AddTransactionView: View {
    var viewModel: RecentsViewModel
    /// Transaction properties
    @Bindable var transaction: Transaction
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = 0
    @State private var dateAdded: Date = .init()
    @State private var category: Category = .expense
    @Binding var selectedCategory: Category
    /// View properties
    @Binding var showSheet: Bool
    var comeFromDetail: Bool
    var tintColor: TintColor = tints.randomElement()!
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    Text("Preview")
                        .font(.caption)
                        .foregroundStyle(.primary.secondary)
                        .hSpacing(.leading)
                    
                    //MARK: Transaction Preview
                    if comeFromDetail {
                        TransactionCardView(transaction: transaction)
                    } else {
                        TransactionCardView(transaction: .init(title: title.isEmpty ? "Título" : title, remarks: remarks.isEmpty ? "Observaciones" : remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tintColor))
                    }
                    
                    //MARK: Sections
                    CustomSection("Título", value: comeFromDetail ? $transaction.title : $title)
                    CustomSection("Observaciones", value: comeFromDetail ? $transaction.remarks : $remarks)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total")
                                .formatTitleSectionNewTransaction()
                            
                            Text("Categoría")
                                .hSpacing(.trailing)
                                .formatTitleSectionNewTransaction()
                        }
                        
                        HStack(spacing: 15) {
                            TextField("0.0", value: comeFromDetail ? $transaction.amount : $amount, formatter: .formatter)
                                .formatTextfieldNewTrtansaction()
                                .keyboardType(.decimalPad)

                            CategoryCheckbox()
                                .hSpacing(.trailing)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fecha")
                            .formatTitleSectionNewTransaction()
                        
                        DatePicker("", selection: comeFromDetail ? $transaction.dateAdded : $dateAdded, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .formatTextfieldNewTrtansaction()
                    }
                    
                }
                .padding(15)
            }
            .navigationTitle(comeFromDetail ? transaction.title.capitalized : "Nueva Transacción")
            .background(.gray.opacity(0.15))
            .toolbar {
                if !comeFromDetail {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancelar") {
                            self.showSheet = false
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Guardar") {
                            if !comeFromDetail {
                                let newTransaction: Transaction = .init(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tintColor)
                                viewModel.saveTransaction(newTransaction)
                                if let category = Category.allCases.first(where: { $0.rawValue == newTransaction.category }) {
                                    self.selectedCategory = category
                                }
                            }
                            Task {
                                try? await Task.sleep(for: .seconds(0.3))
                                self.showSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func CustomSection(_ title: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .formatTitleSectionNewTransaction()
            TextField(title, text: value)
                .formatTextfieldNewTrtansaction()
            
        }
    }
    
    @ViewBuilder
    private func CategoryCheckbox() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 6) {
                    ZStack {
                        Image(systemName: "circle")
                            .foregroundStyle(.appTint)
                            .font(.title3)
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.appTint)
                                .font(.caption)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                    if comeFromDetail {
                        transaction.category = category.rawValue
                    }
                }
            }
        }
        .formatTextfieldNewTrtansaction()
        .onAppear {
            if comeFromDetail, let category = Category(rawValue: transaction.category) {
                self.category = category
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTransactionView(viewModel: .init(transactionManager: TransactionManagerTest()), transaction: previewTransaction[0], selectedCategory: .constant(.expense), showSheet: .constant(true), comeFromDetail: false)
    }
}
