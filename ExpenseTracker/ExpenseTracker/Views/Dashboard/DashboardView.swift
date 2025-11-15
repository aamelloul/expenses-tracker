//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: ExpenseViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.medium) {
                    // Summary Cards
                    LazyVGrid(columns: columns, spacing: AppConstants.Spacing.medium) {
                        SummaryCardView(
                            title: "Total Expenses",
                            value: viewModel.totalExpenses.currencyFormatted,
                            icon: "dollarsign.circle.fill",
                            color: AppConstants.Colors.primary,
                            subtitle: "\(viewModel.filteredExpenses.count) transactions"
                        )

                        SummaryCardView(
                            title: "This Month",
                            value: viewModel.monthlyTotal.currencyFormatted,
                            icon: "calendar",
                            color: AppConstants.Colors.secondary
                        )

                        if let topCategory = viewModel.topCategory {
                            SummaryCardView(
                                title: "Top Category",
                                value: topCategory.total.currencyFormatted,
                                icon: topCategory.category.icon,
                                color: topCategory.category.color,
                                subtitle: topCategory.category.rawValue
                            )
                        } else {
                            SummaryCardView(
                                title: "Top Category",
                                value: "$0.00",
                                icon: "star.fill",
                                color: .gray,
                                subtitle: "No data"
                            )
                        }

                        SummaryCardView(
                            title: "Daily Average",
                            value: viewModel.dailyAverage.currencyFormatted,
                            icon: "chart.line.uptrend.xyaxis",
                            color: AppConstants.Colors.warning
                        )
                    }

                    // Spending Chart
                    SpendingChartView(
                        categoryBreakdown: viewModel.categoryBreakdown,
                        totalAmount: viewModel.totalExpenses
                    )

                    // Recent Expenses
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        HStack {
                            Text("Recent Expenses")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }

                        if viewModel.recentExpenses.isEmpty {
                            Text("No expenses yet")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, AppConstants.Spacing.large)
                        } else {
                            ForEach(viewModel.recentExpenses) { expense in
                                ExpenseRowView(expense: expense)
                            }
                        }
                    }
                    .padding(AppConstants.Spacing.medium)
                    .cardStyle()
                }
                .padding(AppConstants.Spacing.medium)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            if let url = viewModel.exportToCSV() {
                                shareFile(url: url)
                            }
                        }) {
                            Label("Export CSV", systemImage: "doc.text")
                        }

                        Button(action: {
                            if let url = viewModel.exportToJSON() {
                                shareFile(url: url)
                            }
                        }) {
                            Label("Export JSON", systemImage: "doc.text")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }

    private func shareFile(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
