//
//  Category.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case bills = "Bills"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transportation:
            return "car.fill"
        case .entertainment:
            return "tv.fill"
        case .shopping:
            return "cart.fill"
        case .bills:
            return "doc.text.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food:
            return Color.orange
        case .transportation:
            return Color.blue
        case .entertainment:
            return Color.purple
        case .shopping:
            return Color.pink
        case .bills:
            return Color.red
        case .other:
            return Color.gray
        }
    }
}
