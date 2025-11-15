//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: AppConstants.Spacing.medium) {
            CategoryIcon(category: expense.category, size: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.description)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)

                HStack {
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(expense.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text(expense.formattedAmount)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(AppConstants.Colors.primary)
        }
        .padding(AppConstants.Spacing.small)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(AppConstants.CornerRadius.small)
    }
}
