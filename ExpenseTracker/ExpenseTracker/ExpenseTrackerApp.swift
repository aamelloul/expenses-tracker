//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject private var viewModel = ExpenseViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel

    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie.fill")
                }

            ExpenseListView(viewModel: viewModel)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
        }
        .accentColor(AppConstants.Colors.primary)
    }
}
