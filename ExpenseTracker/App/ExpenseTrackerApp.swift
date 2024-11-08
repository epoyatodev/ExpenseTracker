//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Enrique Poyato Ortiz on 31/10/24.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("isAppLockBackground") private var isAppLockBackground: Bool = false
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
