//
// HeaderView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct HeaderView: View {
    @Binding var showAddTransaction: Bool
    @AppStorage("username") private var username: String = ""
    var recentsViewModel: RecentsViewModel
    let size: CGSize
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Bienvenid@")
                    .font(.title.bold())
                Text(username)
                    .font(.caption)
                    .foregroundStyle(.primary.secondary)
            }
            .visualEffect({ content, geometryProxy in
                content
                    .scaleEffect({
                        let minY = geometryProxy.frame(in: .scrollView).minY
                        let height = size.height
                        let progress = minY / height
                        let scale = (min(max(progress, 0), 1)) * 0.5
                        return 1 + scale
                    }(), anchor: .topLeading)
            })
            Spacer(minLength: 0)
            
            Button {
                self.showAddTransaction = true
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(.appTint, in: .circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, username.isEmpty ? 5 : 10)
        .background(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()
            }
                .visualEffect({ content, geometryProxy in
                    content
                        .opacity(.headerBGOpacity(geometryProxy, view: self))
                    
                })
                .padding(.horizontal, -15) // 15 -> LazyVStack padding
                .padding(.top, -(safeArea.top + 15))
            
        )    }
}

#Preview {
    HeaderView(showAddTransaction: .constant(true), recentsViewModel: .init(transactionManager: TransactionManagerTest()), size: CGSize(width:200 , height: 200))
}
