//
// RecentsView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import ScrollViewSwipeActions

struct RecentsView: View {
    @State private var startDate: Date = .now.startOnMonth
    @State private var endDate: Date = .now.endOnMonth
    @State private var selectedcategory: Category = .income
    @State private var transactions: [Transaction] = []
    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            //MARK: Date filter button
                            Button {
                                
                            } label: {
                                Text("\(format(date: startDate, format: "dd MMM yy")) - \(format(date: endDate, format: "dd MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            .hSpacing(.leading)
                            
                            //MARK: Card View
                            CardView(income: 3200, expense: 1460)
                            
                            //MARK: Segmented control
                            CustomSegmentedControl(selectedCategory: $selectedcategory)
                        
                            //MARK: Transactions
                            ForEach(transactions.filter({$0.category == self.selectedcategory.rawValue})) { transaction in
                                CustomSwipeAction(cornerRadius: 15, direction: .trailing) {
                                    TransactionCardView(transaction: transaction)
                                } actions: {
                                    Action(tint: .blue, icon: "star.fill", isEnabled: false) {
                                        
                                    }
                                    Action(tint: .red, icon: "trash.fill") {
                                        withAnimation(.easeInOut) {
                                            transactions.removeAll(where: {$0.id == transaction.id})
                                        }
                                    }
                                }
                            }
                        } header: {
                            HeaderView(size: size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .onChange(of: self.selectedcategory) { _, newValue in
                    NotificationCenter.default.post(name: .init("hola"), object: nil)
                }
            }
        }
        .onAppear {
            self.transactions = previewTransaction
        }
    }
}

#Preview {
    RecentsView()
}
