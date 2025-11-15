//
//  FilterView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedCategory: Category?
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quick Filters")) {
                    ForEach(DateFilterPeriod.allCases, id: \.self) { period in
                        Button(action: {
                            viewModel.setDateFilter(period: period)
                            dismiss()
                        }) {
                            HStack {
                                Text(period.rawValue)
                                Spacer()
                                if isCurrentFilter(period) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppConstants.Colors.primary)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        Text("All Categories").tag(nil as Category?)
                        ForEach(Category.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category as Category?)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Custom Date Range")) {
                    Button(action: {
                        showStartDatePicker.toggle()
                    }) {
                        HStack {
                            Text("Start Date")
                            Spacer()
                            if let date = startDate {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not Set")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .foregroundColor(.primary)

                    if showStartDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    }

                    Button(action: {
                        showEndDatePicker.toggle()
                    }) {
                        HStack {
                            Text("End Date")
                            Spacer()
                            if let date = endDate {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not Set")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .foregroundColor(.primary)

                    if showEndDatePicker {
                        DatePicker(
                            "End Date",
                            selection: Binding(
                                get: { endDate ?? Date() },
                                set: { endDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    }
                }

                Section {
                    Button(action: {
                        applyCustomFilters()
                        dismiss()
                    }) {
                        Text("Apply Filters")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }

                    Button(action: {
                        viewModel.clearFilter()
                        selectedCategory = nil
                        startDate = nil
                        endDate = nil
                    }) {
                        Text("Clear All Filters")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedCategory = viewModel.filter.selectedCategory
                startDate = viewModel.filter.startDate
                endDate = viewModel.filter.endDate
            }
        }
    }

    private func applyCustomFilters() {
        viewModel.filter.selectedCategory = selectedCategory
        viewModel.filter.startDate = startDate
        viewModel.filter.endDate = endDate
    }

    private func isCurrentFilter(_ period: DateFilterPeriod) -> Bool {
        let now = Date()

        switch period {
        case .all:
            return viewModel.filter.startDate == nil && viewModel.filter.endDate == nil
        case .today:
            guard let start = viewModel.filter.startDate,
                  let end = viewModel.filter.endDate else {
                return false
            }
            return start.isSameDay(as: now) && end.isSameDay(as: now)
        case .thisMonth:
            guard let start = viewModel.filter.startDate else {
                return false
            }
            return start.isSameDay(as: now.startOfMonth)
        default:
            return false
        }
    }
}
