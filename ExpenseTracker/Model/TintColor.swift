//
// TintColor.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

/// Custom tint color for transaction
struct TintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Green", value: .green),
    .init(color: "Blue", value: .blue),
    .init(color: "Yellow", value: .yellow),
    .init(color: "Purple", value: .purple),
    .init(color: "Pink", value: .pink),
]
