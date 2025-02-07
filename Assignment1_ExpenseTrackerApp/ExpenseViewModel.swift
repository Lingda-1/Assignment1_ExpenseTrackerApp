//
//  ExpenseViewModel.swift
//  Assignment1_ExpenseTrackerApp
//
//  Created by user on 2025-02-02.
//

import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses() // Save whenever changes occur
        }
    }
    
    @Published var selectedCategory: ExpenseCategory? = nil
    
    init() {
        loadExpenses()
        
        // If no expenses exist, add a sample expense
        if expenses.isEmpty {
            expenses = [Expense(amount: 10, description: "Sample", category: .food, date: Date())]
        }
    }
    
    // Function to add a new expense
    func addExpense(amount: Double, description: String, category: ExpenseCategory) {
        let newExpense = Expense(amount: amount, description: description, category: category, date: Date()) // Uses current date
        expenses.append(newExpense)
        saveExpenses()
    }
    
    // Function to delete an expense
    func removeExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveExpenses()
    }
    
    // Function to filter expenses by category
    var filteredExpenses: [Expense] {
        if let category = selectedCategory {
            return expenses.filter { $0.category == category }
        }
        return expenses
    }
    
    // Function to calculate total expenses
    var totalExpense: Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }
    
    // Function to get total expenses by category
    var expensesByCategory: [ExpenseCategory: Double] {
        var categoryTotals: [ExpenseCategory: Double] = [:]
        for expense in expenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        return categoryTotals
    }
    
    // Function to get total expenses by month
    var expensesByMonth: [String: Double] {
        var monthTotals: [String: Double] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"  // Example: "January 2025"
        
        for expense in expenses {
            let month = formatter.string(from: expense.date) // Uses actual date
            monthTotals[month, default: 0] += expense.amount
        }
        return monthTotals
    }
    
    // Function to save expenses using UserDefaults
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: "expenses")
        }
    }
    
    // Function to load expenses from UserDefaults
    private func loadExpenses() {
        if let savedExpenses = UserDefaults.standard.data(forKey: "expenses"),
           let decoded = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
            expenses = decoded
        }
    }
}
