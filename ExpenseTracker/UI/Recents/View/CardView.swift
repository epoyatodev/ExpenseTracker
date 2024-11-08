//
// CardView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    var savings: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("\(currencyString(income - expense - savings))")
                        .font(.title.bold())
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        let symbol = category == .income ? "arrow.down" : category == .expense ? "arrow.up" : "envelope.fill"
                        let tint = category == .income ? Color.green : category == .expense ? Color.red : Color.blue
                        HStack(spacing: 10) {
                            Image(systemName: symbol)
                                .font(.callout)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(tint)
                                .background(tint.opacity(0.25), in: .circle)
                                
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                switch category {
                                case .income:
                                    Text(currencyString(income, allowedDigits: 0))
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                case .expense:
                                    Text(currencyString(expense, allowedDigits: 0))
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                case .savings:
                                    Text(currencyString(savings, allowedDigits: 0))
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                }
                                
                            }
                            
                        }
                        .hSpacing()
                    }
                }
            }
            .padding(.bottom, 25)
            .padding(.top, 15)
        }
    }
}

#Preview {
    CardView(income: 5, expense: 565, savings: 1500)
}
