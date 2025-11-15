//
//  ExportManager.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import Foundation

class ExportManager {
    static let shared = ExportManager()

    private init() {}

    func exportToCSV(expenses: [Expense]) -> URL? {
        var csvString = "Date,Category,Amount,Description\n"

        let sortedExpenses = expenses.sorted { $0.date > $1.date }

        for expense in sortedExpenses {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none

            let date = dateFormatter.string(from: expense.date)
            let category = expense.category.rawValue
            let amount = String(format: "%.2f", expense.amount)
            let description = expense.description.replacingOccurrences(of: ",", with: ";")

            csvString.append("\(date),\(category),\(amount),\(description)\n")
        }

        let fileName = "expenses_\(Date().timeIntervalSince1970).csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Error exporting CSV: \(error.localizedDescription)")
            return nil
        }
    }

    func exportToJSON(expenses: [Expense]) -> URL? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(expenses)
            let fileName = "expenses_\(Date().timeIntervalSince1970).json"
            let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try data.write(to: path)
            return path
        } catch {
            print("Error exporting JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
