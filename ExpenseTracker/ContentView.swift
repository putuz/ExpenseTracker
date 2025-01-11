//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Your Future on 11/01/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = ExpenseViewModel()
    @State private var showAddExpenseView = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Total Expenses
                HStack {
                    Text("Total Expenses")
                        .font(.headline)
                    Spacer()
                    Text(vm.totalExpenses, format: .currency(code: "USD"))
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .padding()
                
                // Expenses by Category
                List {
                    Section(header: Text("Expenses by Category")) {
                        ForEach(vm.expensesByCategory.keys.sorted(by: { $0.title < $1.title }), id: \.self) { category in
                            HStack {
                                Text("\(category.icon) \(category.title)")
                                Spacer()
                                Text(vm.expensesByCategory[category] ?? 0, format: .currency(code: "USD"))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    }
                    
                    // All Expenses
                    Section(header: Text("All Expenses")) {
                        ForEach(vm.expenses) { expense in
                            VStack(alignment: .leading) {
                                Text(expense.title)
                                    .font(.headline)
                                Text(expense.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(expense.amount, format: .currency(code: "USD"))
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    vm.deleteExpense(context: context, expense: expense)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Expense Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddExpenseView.toggle()
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                vm.fetchExpenses(context: context)
            }
            .sheet(isPresented: $showAddExpenseView) {
                AddExpenseView(viewModel: vm, context: context)
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: [Expense.self])
}
