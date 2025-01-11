//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Your Future on 11/01/25.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Expense.self])
        }
    }
}
