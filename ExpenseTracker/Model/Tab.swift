//
// Tab.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case recents = "Recientes"
    case search = "Buscar"
    case charts = "Gráficos"
    case settings = "Ajustes"
    
    var image: String {
        switch self {
        case .recents:
            "calendar"
        case .search:
            "magnifyingglass"
        case .charts:
            "chart.bar.xaxis"
        case .settings:
            "gearshape"
        }
    }
}
