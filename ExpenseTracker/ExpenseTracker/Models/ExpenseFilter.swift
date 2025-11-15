//
//  ExpenseFilter.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import Foundation

struct ExpenseFilter {
    var searchText: String = ""
    var selectedCategory: Category?
    var startDate: Date?
    var endDate: Date?

    func matches(_ expense: Expense) -> Bool {
        // Search text filter
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            let matchesDescription = expense.description.lowercased().contains(searchLower)
            let matchesCategory = expense.category.rawValue.lowercased().contains(searchLower)
            let matchesAmount = expense.formattedAmount.contains(searchText)

            if !matchesDescription && !matchesCategory && !matchesAmount {
                return false
            }
        }

        // Category filter
        if let category = selectedCategory, expense.category != category {
            return false
        }

        // Date range filter
        if let start = startDate, expense.date < start {
            return false
        }

        if let end = endDate {
            let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end
            if expense.date > endOfDay {
                return false
            }
        }

        return true
    }
}
