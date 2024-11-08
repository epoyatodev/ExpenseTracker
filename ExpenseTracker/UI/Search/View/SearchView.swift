//
// SearchView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import Combine

struct SearchView: View {
    @State var viewModel: SearchViewModel = .init()
    @Environment(RecentsViewModel.self) var recentsViewmodel
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    let searchPublisher = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.transactionsResults) { transaction in
                        NavigationLink {
                            AddTransactionView(viewModel: recentsViewmodel, transaction: transaction, selectedCategory: .constant(.expense), showSheet: .constant(false), comeFromDetail: true)
                        } label: {
                            TransactionCardView(transaction: transaction)
                        }
                    }
                }
                .padding(15)
            }
            .searchable(text: $searchText)
            .overlay {
                ContentUnavailableView("Buscar Transacciones", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            }
            .onChange(of: searchText, { oldValue, newValue in
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                self.filterText = text
                self.viewModel.search(category: nil, filterText: filterText)
            })
            .navigationTitle("Buscar")
            .background(.primary.secondary.opacity(0.15))
        }
        
    }
}

#Preview {
    SearchView(viewModel: .init(transactionManager: TransactionManagerTest()))
        .environment(RecentsViewModel(transactionManager: TransactionManagerTest()))
}
