//
// GraphsView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import Charts

struct GraphsView: View {
    @State private var viewModel: GraphsViewModel = .init()
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    //MARK: Chart
                    ChartView(chartGroups: viewModel.chartGroups)
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    //MARK: CARDS
                    ForEach(viewModel.chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.primary.secondary)
                                .hSpacing(.leading)
                            
                            CardView(income: group.totalIncome, expense: group.totalExpense, savings: group.totalSavings)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Progreso")
            .background(.gray.opacity(0.15))
            .task {
                viewModel.createCharrtGroups()
            }
        }
    }
}

#Preview {
    GraphsView()
}
