//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import Foundation
import SwiftUI

@MainActor
class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var filter: ExpenseFilter = ExpenseFilter()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingExportSuccess: Bool = false

    private let persistenceManager = PersistenceManager.shared
    private let exportManager = ExportManager.shared

    init() {
        loadExpenses()
    }

    // MARK: - Computed Properties

    var filteredExpenses: [Expense] {
        expenses.filter { filter.matches($0) }
            .sorted { $0.date > $1.date }
    }

    var totalExpenses: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    var monthlyTotal: Double {
        let thisMonth = Date()
        return expenses.filter { $0.date.isSameMonth(as: thisMonth) }
            .reduce(0) { $0 + $1.amount }
    }

    var categoryBreakdown: [(category: Category, total: Double)] {
        var breakdown: [Category: Double] = [:]

        for expense in filteredExpenses {
            breakdown[expense.category, default: 0] += expense.amount
        }

        return breakdown.map { (category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }

    var topCategory: (category: Category, total: Double)? {
        categoryBreakdown.first
    }

    var recentExpenses: [Expense] {
        filteredExpenses.prefix(5).map { $0 }
    }

    var dailyAverage: Double {
        guard !filteredExpenses.isEmpty else { return 0 }

        let dates = filteredExpenses.map { $0.date.startOfDay }
        guard let earliestDate = dates.min(),
              let latestDate = dates.max() else {
            return 0
        }

        let days = Calendar.current.dateComponents([.day], from: earliestDate, to: latestDate).day ?? 1
        let totalDays = max(days, 1)

        return totalExpenses / Double(totalDays)
    }

    var monthlyExpensesByCategory: [Category: [Double]] {
        var result: [Category: [Double]] = [:]

        for category in Category.allCases {
            result[category] = []
        }

        // Get last 6 months
        let calendar = Calendar.current
        for monthOffset in 0..<6 {
            guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: Date()) else {
                continue
            }

            for category in Category.allCases {
                let monthExpenses = expenses.filter {
                    $0.category == category && $0.date.isSameMonth(as: monthDate)
                }
                let total = monthExpenses.reduce(0) { $0 + $1.amount }
                result[category]?.append(total)
            }
        }

        return result
    }

    // MARK: - Actions

    func loadExpenses() {
        isLoading = true
        expenses = persistenceManager.loadExpenses()
        isLoading = false
    }

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }

    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            saveExpenses()
        }
    }

    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }

    func deleteExpenses(at offsets: IndexSet) {
        let expensesToDelete = offsets.map { filteredExpenses[$0] }
        expenses.removeAll { expense in
            expensesToDelete.contains(where: { $0.id == expense.id })
        }
        saveExpenses()
    }

    private func saveExpenses() {
        persistenceManager.saveExpenses(expenses)
    }

    func exportToCSV() -> URL? {
        exportManager.exportToCSV(expenses: filteredExpenses)
    }

    func exportToJSON() -> URL? {
        exportManager.exportToJSON(expenses: filteredExpenses)
    }

    func clearFilter() {
        filter = ExpenseFilter()
    }

    func setDateFilter(period: DateFilterPeriod) {
        let now = Date()

        switch period {
        case .today:
            filter.startDate = now.startOfDay
            filter.endDate = now.endOfDay
        case .thisWeek:
            let weekStart = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))
            filter.startDate = weekStart
            filter.endDate = now
        case .thisMonth:
            filter.startDate = now.startOfMonth
            filter.endDate = now.endOfMonth
        case .lastMonth:
            let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: now) ?? now
            filter.startDate = lastMonth.startOfMonth
            filter.endDate = lastMonth.endOfMonth
        case .thisYear:
            filter.startDate = now.startOfYear
            filter.endDate = now
        case .all:
            filter.startDate = nil
            filter.endDate = nil
        }
    }

    // Validation
    func validateExpense(amount: String, description: String) -> String? {
        if description.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Description cannot be empty"
        }

        guard let amountValue = Double(amount), amountValue > 0 else {
            return "Amount must be greater than 0"
        }

        if amountValue > 1000000 {
            return "Amount seems unreasonably large"
        }

        return nil
    }
}

enum DateFilterPeriod: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    case thisYear = "This Year"
    case all = "All Time"
}
