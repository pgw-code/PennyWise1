//
//  FinanceChartView.swift
//  PennyWise
//
//  Created by Praveen Wadikar on 8/4/24.
//

import SwiftUI
import CoreData
import Charts

struct FinanceChartView: View {
   // var transactions: FetchedResults<Transaction>
    var transactions: [Transaction]
    var totalIncome: Double {
        transactions.filter { $0.type == "income" }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        transactions.filter { $0.type == "expense" }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack {
            Text("Income vs Expense")
                .font(.title)
                .padding()
            
            if transactions.isEmpty {
                Text("No transactions available to display")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart {
                    BarMark(
                        x: .value("Category", "Income"),
                        y: .value("Amount", totalIncome)
                    )
                    .foregroundStyle(Color.green)
                    
                    BarMark(
                        x: .value("Category", "Expense"),
                        y: .value("Amount", totalExpense)
                    )
                    .foregroundStyle(Color.red)
                }
                .frame(height: 300)
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            print("Total Income: \(totalIncome)")
            print("Total Expense: \(totalExpense)")
            print("Transaction Count: \(transactions.count)")
        }
    }
}
