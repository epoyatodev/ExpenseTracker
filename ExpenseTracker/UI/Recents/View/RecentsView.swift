//
// RecentsView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct RecentsView: View {
    @Environment(RecentsViewModel.self) var viewModel
    @State private var startDate: Date = .now.startOnMonth
    @State private var endDate: Date = .now.endOnMonth
    @State private var selectedcategory: Category = .income
    @State private var showFilterView: Bool = false
    @State private var showAddTransaction: Bool = false
    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            //MARK: Date filter button
                            Button {
                                self.showFilterView = true
                            } label: {
                                Text("\(format(date: startDate, format: "dd MMM yy")) - \(format(date: endDate, format: "dd MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            .hSpacing(.leading)
                            
                            //MARK: Card View
                            CardView(income: viewModel.getIncomeAmmount(), expense: viewModel.getExpenseAmount(), savings: viewModel.getSavingsAmmount())
                            
                            //MARK: Segmented control
                            CustomSegmentedControl(selectedCategory: $selectedcategory)
                        
                            //MARK: Transactions
                            ForEach(viewModel.transactions.filter({($0.category == self.selectedcategory.rawValue)})) { transaction in
                                CustomSwipeAction(cornerRadius: 15, direction: .trailing) {
                                    NavigationLink {
                                        AddTransactionView(viewModel: self.viewModel, transaction: transaction, selectedCategory: $selectedcategory, showSheet: $showAddTransaction, comeFromDetail: true)
                                    } label: {
                                        TransactionCardView(transaction: transaction)
                                    }
                                    .foregroundStyle(.primary)
                                    
                                } actions: {
                                    Action(tint: .red, icon: "trash.fill") {
                                        withAnimation(.easeInOut) {
                                            self.viewModel.removeTransaction(transaction)
                                        }
                                    }
                                }
                                
                            }
                        } header: {
                            HeaderView(showAddTransaction: $showAddTransaction, recentsViewModel: self.viewModel, size: size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .onChange(of: self.selectedcategory) { _, newValue in
                    NotificationCenter.default.post(name: .selectedcategoryChanged, object: nil)
                }
                .animation(.snappy, value: viewModel.transactions)
                .blur(radius: self.showFilterView ? 8 : 0)
                .disabled(self.showFilterView)
            }
            .overlay {
                if showFilterView {
                    DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                        self.startDate = start
                        self.endDate = end
                        self.showFilterView = false
                        self.viewModel.getTransactions(startDate: start, endDate: end)
                    }, onClose: {
                        self.showFilterView = false
                    })
                        .transition(.move(edge: .leading))
                }
            }
            .ignoresSafeArea(.keyboard)
            .animation(.snappy, value: showFilterView)
            .fullScreenCover(isPresented: $showAddTransaction) {
                AddTransactionView(viewModel: self.viewModel, transaction: .emptyTransaction , selectedCategory: $selectedcategory, showSheet: $showAddTransaction, comeFromDetail: false)
            }
            .task {
                self.viewModel.getTransactions(startDate: startDate, endDate: endDate)
            }
        }
    }
}

#Preview {
    RecentsView()
        .environment(RecentsViewModel(transactionManager: TransactionManagerTest()))
}

