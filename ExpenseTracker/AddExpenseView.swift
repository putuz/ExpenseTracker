//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Your Future on 11/01/25.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ExpenseViewModel
    var context: ModelContext
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var category: Categories = .other
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $category) {
                    ForEach(Categories.allCases, id: \.self) { category in
                        Text(category.title).tag(category)
                    }
                }
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let expenseAmount = Double(amount) {
                            viewModel.addExpense(context: context, amount: expenseAmount, title: title, category: category, date: date)
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddExpenseView(viewModel: ExpenseViewModel(), context: ModelContext(try! ModelContainer(for: Expense.self)))
}
