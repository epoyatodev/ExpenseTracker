//
// PointView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct PointView: View {
    var image: String
    var text: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: image)
                .foregroundStyle(.appTint)
            Text(text)
                .font(.footnote)
                .bold()
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        )
    }
}

#Preview {
    PointView(image: "person", text: "example")
        .padding()
}
