//
//  Models.swift
//  ExpenseTracker
//
//  Created by Your Future on 11/01/25.
//

import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID = UUID()
    var amount: Double
    var title: String
    var date: Date
    var category: Categories
    
    init(amount: Double, title: String, date: Date = Date(), category: Categories) {
        self.amount = amount
        self.title = title
        self.date = date
        self.category = category
    }
}

enum Categories: Int, Codable, CaseIterable {
    case food
    case transport
    case shopping
    case bills
    case other
    
    var icon: String {
        switch self {
        case .food: return "🍽️"
        case .transport: return "🚗"
        case .shopping: return "🛍️"
        case .bills: return "💰"
        case .other: return "📝"
        }
    }
    
    var title: String {
        switch self {
        case .food: return "Food"
        case .transport: return "Transport"
        case .shopping: return "Shopping"
        case .bills: return "Bills"
        case .other: return "Other"
        }
    }
}
