//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Enrique Poyato Ortiz on 31/10/24.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    /// Intro Visibility Status
    @AppStorage("showResume") var showResume: Bool = true
    @State var viewModel: RecentsViewModel = .init()

    var body: some View {
        TabView {
            Tab.init(TabItem.recents.rawValue, systemImage: TabItem.recents.image) {
                RecentsView()
                    .environment(viewModel)
            }
            Tab.init(TabItem.search.rawValue, systemImage: TabItem.search.image) {
                SearchView()
                    .environment(viewModel)
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
        .onAppear {
        }
    }
}

#Preview {
    TabBarView()
}


