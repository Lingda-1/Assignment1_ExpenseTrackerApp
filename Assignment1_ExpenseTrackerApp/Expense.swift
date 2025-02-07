//
//  Expense.swift
//  Assignment1_ExpenseTrackerApp
//
//  Created by user on 2025-02-02.
//

import Foundation

// Expense Model
struct Expense: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var description: String
    var category: ExpenseCategory
    var date: Date
}

// Enum for Expense Categories
enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case travel = "Travel"
    case bills = "Bills"
    case entertainment = "Entertainment"
    case other = "Other"
}
