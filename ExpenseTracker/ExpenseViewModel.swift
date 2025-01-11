//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Your Future on 11/01/25.
//

import Foundation
import SwiftData

class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published var totalExpenses: Double = 0.0
    @Published var expensesByCategory: [Categories: Double] = [:]
    
    // MARK: - Fetch Operations
    func fetchExpenses(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\Expense.date, order: .reverse)])
        
        do {
            expenses = try context.fetch(fetchDescriptor)
            calculateTotalExpenses()
            calculateExpensesByCategory()
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Operations
    func addExpense(context: ModelContext, amount: Double, title: String, category: Categories, date: Date = Date()) {
        let newExpense = Expense(amount: amount, title: title, date: date, category: category)
        context.insert(newExpense)
        
        do {
            try context.save()
            fetchExpenses(context: context)
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
    
    func deleteExpense(context: ModelContext, expense: Expense) {
        context.delete(expense)
        
        do {
            try context.save()
            fetchExpenses(context: context)
        } catch {
            print("Error deleting expense: \(error.localizedDescription)")
        }
    }
    
    func updateExpense(context: ModelContext, expense: Expense, amount: Double, title: String, category: Categories, date: Date) {
        expense.amount = amount
        expense.title = title
        expense.category = category
        expense.date = date
        
        do {
            try context.save()
            fetchExpenses(context: context)
        } catch {
            print("Error updating expense: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Calculations
    private func calculateTotalExpenses() {
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
    }
    
    private func calculateExpensesByCategory() {
        expensesByCategory = Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { expenses in
                expenses.reduce(0) { $0 + $1.amount }
            }
    }
    
    // MARK: - Filtering
    func expenses(for category: Categories) -> [Expense] {
        expenses.filter { $0.category == category }
    }
    
    func expenses(for dateRange: ClosedRange<Date>) -> [Expense] {
        expenses.filter { dateRange.contains($0.date) }
    }
    
    // MARK: - Statistics
    func averageExpense(for category: Categories? = nil) -> Double {
        let filteredExpenses = category.map { expenses(for: $0) } ?? expenses
        guard !filteredExpenses.isEmpty else { return 0 }
        return filteredExpenses.reduce(0) { $0 + $1.amount } / Double(filteredExpenses.count)
    }
    
    func highestExpense(for category: Categories? = nil) -> Expense? {
        let filteredExpenses = category.map { expenses(for: $0) } ?? expenses
        return filteredExpenses.max(by: { $0.amount < $1.amount })
    }
}
