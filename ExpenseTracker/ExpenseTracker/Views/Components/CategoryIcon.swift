//
//  CategoryIcon.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct CategoryIcon: View {
    let category: Category
    let size: CGFloat

    init(category: Category, size: CGFloat = 40) {
        self.category = category
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(category.color.opacity(0.2))
                .frame(width: size, height: size)

            Image(systemName: category.icon)
                .font(.system(size: size * 0.5))
                .foregroundColor(category.color)
        }
    }
}
