//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import Foundation

struct Expense: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var category: Category
    var description: String
    var date: Date

    init(id: UUID = UUID(), amount: Double, category: Category, description: String, date: Date) {
        self.id = id
        self.amount = amount
        self.category = category
        self.description = description
        self.date = date
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
