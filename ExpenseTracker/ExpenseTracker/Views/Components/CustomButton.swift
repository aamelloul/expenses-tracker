//
//  CustomButton.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var style: ButtonStyle = .primary
    var fullWidth: Bool = false

    enum ButtonStyle {
        case primary
        case secondary
        case danger

        var backgroundColor: Color {
            switch self {
            case .primary:
                return AppConstants.Colors.primary
            case .secondary:
                return AppConstants.Colors.secondary
            case .danger:
                return AppConstants.Colors.danger
            }
        }

        var foregroundColor: Color {
            return .white
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(AppConstants.CornerRadius.medium)
        }
    }
}
