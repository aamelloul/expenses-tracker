//
//  PersistenceManager.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import Foundation

class PersistenceManager: @unchecked Sendable {
    static let shared = PersistenceManager()

    private let expensesKey = "expenses_data"
    private let userDefaults = UserDefaults.standard

    private init() {}

    func saveExpenses(_ expenses: [Expense]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(expenses)
            userDefaults.set(data, forKey: expensesKey)
        } catch {
            print("Error saving expenses: \(error.localizedDescription)")
        }
    }

    func loadExpenses() -> [Expense] {
        guard let data = userDefaults.data(forKey: expensesKey) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let expenses = try decoder.decode([Expense].self, from: data)
            return expenses
        } catch {
            print("Error loading expenses: \(error.localizedDescription)")
            return []
        }
    }

    func deleteAllExpenses() {
        userDefaults.removeObject(forKey: expensesKey)
    }
}
