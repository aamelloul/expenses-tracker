//
//  ExpenseFormView.swift
//  ExpenseTracker
//
//  Created by Claude on 2025-11-15.
//

import SwiftUI

struct ExpenseFormView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss

    let expenseToEdit: Expense?

    @State private var amount: String = ""
    @State private var category: Category = .food
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""

    init(viewModel: ExpenseViewModel, expenseToEdit: Expense? = nil) {
        self.viewModel = viewModel
        self.expenseToEdit = expenseToEdit

        if let expense = expenseToEdit {
            _amount = State(initialValue: String(format: "%.2f", expense.amount))
            _category = State(initialValue: expense.category)
            _description = State(initialValue: expense.description)
            _date = State(initialValue: expense.date)
        }
    }

    var isEditing: Bool {
        expenseToEdit != nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount")) {
                    HStack {
                        Text("$")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }

                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases) { cat in
                            HStack {
                                Image(systemName: cat.icon)
                                    .foregroundColor(cat.color)
                                Text(cat.rawValue)
                            }
                            .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)

                    // Category preview
                    HStack {
                        CategoryIcon(category: category, size: 60)
                        Text(category.rawValue)
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppConstants.Spacing.small)
                }

                Section(header: Text("Description")) {
                    TextField("Enter description", text: $description)
                        .textInputAutocapitalization(.sentences)
                }

                Section(header: Text("Date")) {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: .date
                    )
                }

                Section {
                    Button(action: saveExpense) {
                        HStack {
                            Spacer()
                            Text(isEditing ? "Update Expense" : "Add Expense")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(amount.isEmpty || description.isEmpty)
                }
            }
            .navigationTitle(isEditing ? "Edit Expense" : "New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveExpense() {
        // Validate
        if let error = viewModel.validateExpense(amount: amount, description: description) {
            errorMessage = error
            showingError = true
            return
        }

        guard let amountValue = Double(amount) else {
            errorMessage = "Invalid amount"
            showingError = true
            return
        }

        if let existingExpense = expenseToEdit {
            // Update existing expense
            let updatedExpense = Expense(
                id: existingExpense.id,
                amount: amountValue,
                category: category,
                description: description,
                date: date
            )
            viewModel.updateExpense(updatedExpense)
        } else {
            // Create new expense
            let expense = Expense(
                amount: amountValue,
                category: category,
                description: description,
                date: date
            )
            viewModel.addExpense(expense)
        }

        dismiss()
    }
}
