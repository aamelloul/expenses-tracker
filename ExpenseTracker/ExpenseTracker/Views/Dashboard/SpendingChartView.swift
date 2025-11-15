//
//  SpendingChartView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct SpendingChartView: View {
    let categoryBreakdown: [(category: Category, total: Double)]
    let totalAmount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Spending by Category")
                .font(.headline)
                .fontWeight(.bold)

            if categoryBreakdown.isEmpty {
                Text("No expenses yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppConstants.Spacing.large)
            } else {
                VStack(spacing: AppConstants.Spacing.small) {
                    ForEach(categoryBreakdown, id: \.category) { item in
                        CategoryBreakdownRow(
                            category: item.category,
                            amount: item.total,
                            percentage: totalAmount > 0 ? (item.total / totalAmount) : 0
                        )
                    }
                }
            }
        }
        .padding(AppConstants.Spacing.medium)
        .cardStyle()
    }
}

struct CategoryBreakdownRow: View {
    let category: Category
    let amount: Double
    let percentage: Double

    var body: some View {
        VStack(spacing: AppConstants.Spacing.tiny) {
            HStack {
                HStack(spacing: AppConstants.Spacing.small) {
                    CategoryIcon(category: category, size: 30)
                    Text(category.rawValue)
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(amount.currencyFormatted)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("\(Int(percentage * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(category.color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
    }
}
