//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Enrique Poyato Ortiz on 31/10/24.
//

import SwiftUI

struct TabBarView: View {
    /// Intro Visibility Status
    @AppStorage("showResume") var showResume: Bool = true
    /// Active Tab
    var body: some View {
        TabView {
            Tab.init(TabItem.recents.rawValue, systemImage: TabItem.recents.image) {
                RecentsView()
            }
            Tab.init(TabItem.search.rawValue, systemImage: TabItem.search.image) {
                SearchView()
            }
            Tab.init(TabItem.charts.rawValue, systemImage: TabItem.charts.image) {
                GraphsView()
            }
            Tab.init(TabItem.settings.rawValue, systemImage: TabItem.settings.image) {
                SettignsView()
            }
        }
        .tint(.appTint)
        .sheet(isPresented: $showResume) {
            AppInfoView()
                .interactiveDismissDisabled()
        }
        
    }
}

#Preview {
    TabBarView()
}


