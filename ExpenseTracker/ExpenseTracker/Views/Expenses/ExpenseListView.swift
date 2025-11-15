//
//  ExpenseListView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var viewModel: ExpenseViewModel

    @State private var showingAddExpense = false
    @State private var showingFilter = false
    @State private var expenseToEdit: Expense?

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.filteredExpenses.isEmpty {
                    emptyStateView
                } else {
                    expenseListView
                }
            }
            .navigationTitle("Expenses")
            .searchable(text: $viewModel.filter.searchText, prompt: "Search expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingFilter = true }) {
                        ZStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)

                            if hasActiveFilters {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 12, y: -12)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                ExpenseFormView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(viewModel: viewModel)
            }
            .sheet(item: $expenseToEdit) { expense in
                ExpenseFormView(viewModel: viewModel, expenseToEdit: expense)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppConstants.Spacing.large) {
            Image(systemName: "tray")
                .font(.system(size: 70))
                .foregroundColor(.secondary)

            Text("No Expenses")
                .font(.title2)
                .fontWeight(.bold)

            Text(hasActiveFilters ? "No expenses match your filters" : "Get started by adding your first expense")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if hasActiveFilters {
                Button(action: {
                    viewModel.clearFilter()
                }) {
                    Text("Clear Filters")
                        .fontWeight(.semibold)
                        .padding(.horizontal, AppConstants.Spacing.large)
                        .padding(.vertical, AppConstants.Spacing.medium)
                        .background(AppConstants.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(AppConstants.CornerRadius.medium)
                }
            } else {
                Button(action: { showingAddExpense = true }) {
                    Text("Add Expense")
                        .fontWeight(.semibold)
                        .padding(.horizontal, AppConstants.Spacing.large)
                        .padding(.vertical, AppConstants.Spacing.medium)
                        .background(AppConstants.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(AppConstants.CornerRadius.medium)
                }
            }
        }
    }

    private var expenseListView: some View {
        ScrollView {
            LazyVStack(spacing: AppConstants.Spacing.small) {
                // Summary header
                VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                    HStack {
                        Text("Total")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.totalExpenses.currencyFormatted)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppConstants.Colors.primary)
                    }

                    if hasActiveFilters {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .foregroundColor(AppConstants.Colors.primary)
                            Text("Filters applied")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("Clear") {
                                viewModel.clearFilter()
                            }
                            .font(.caption)
                            .foregroundColor(AppConstants.Colors.primary)
                        }
                    }
                }
                .padding(AppConstants.Spacing.medium)
                .cardStyle()
                .padding(.horizontal, AppConstants.Spacing.medium)
                .padding(.top, AppConstants.Spacing.small)

                // Expense list
                ForEach(viewModel.filteredExpenses) { expense in
                    Button(action: {
                        expenseToEdit = expense
                    }) {
                        ExpenseRowView(expense: expense)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(action: {
                            expenseToEdit = expense
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button(role: .destructive, action: {
                            viewModel.deleteExpense(expense)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.medium)
            }
            .padding(.bottom, AppConstants.Spacing.medium)
        }
    }

    private var hasActiveFilters: Bool {
        !viewModel.filter.searchText.isEmpty ||
        viewModel.filter.selectedCategory != nil ||
        viewModel.filter.startDate != nil ||
        viewModel.filter.endDate != nil
    }
}
