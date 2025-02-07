//
//  ContentView.swift
//  Assignment1_ExpenseTrackerApp
//
//  Created by user on 2025-02-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: ExpenseCategory = .food
    
    var body: some View {
        NavigationView {
            VStack {
                // Expense Input Form
                Form {
                    Section(header: Text("Add New Expense")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $description)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    }
                    
                    Button(action: addExpense) {
                        Text("Add Expense")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                // Expense List & Total
                List {
                    Section(header: Text("Total Expense: $\(viewModel.totalExpense, specifier: "%.2f")")) {
                        ForEach(viewModel.filteredExpenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.description)
                                        .font(.headline)
                                    Text("Category: \(expense.category.rawValue)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Date: \(expense.date.formatted(.dateTime.year().month().day()))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("$\(expense.amount, specifier: "%.2f")")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onDelete(perform: viewModel.removeExpense) // Enable deleting expenses
                    }
                    
                    // Breakdown by category
                    Section(header: Text("Expenses by Category")) {
                        ForEach(viewModel.expensesByCategory.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { category, total in
                            HStack {
                                Text(category.rawValue)
                                Spacer()
                                Text("$\(total, specifier: "%.2f")").foregroundColor(.blue)
                            }
                        }
                    }
                    
                    // Breakdown by month
                    Section(header: Text("Expenses by Month")) {
                        ForEach(viewModel.expensesByMonth.sorted(by: { $0.key < $1.key }), id: \.key) { month, total in
                            HStack {
                                Text(month)
                                Spacer()
                                Text("$\(total, specifier: "%.2f")").foregroundColor(.green)
                            }
                        }
                    }
                }
                
                // Category Filter Picker
                Picker("Filter by Category", selection: $viewModel.selectedCategory) {
                    Text("All").tag(ExpenseCategory?.none)
                    ForEach(ExpenseCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category as ExpenseCategory?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .navigationTitle("Expense Tracker")
        }
    }
    
    // Function to add expense
    private func addExpense() {
        if let expenseAmount = Double(amount) {
            viewModel.addExpense(amount: expenseAmount, description: description, category: selectedCategory)
            amount = ""
            description = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
