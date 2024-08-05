//
//  ContentView.swift
//  PennyWise
//
//  Created by Praveen Wadikar on 8/3/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
    ) var transactions: FetchedResults<Transaction>
    
    @State private var showChart = false  // State variable to toggle chart visibility
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showChart.toggle()  // Toggle the chart visibility
                }) {
                    Text(showChart ? "Hide Chart" : "Show Chart")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                .padding()
                .zIndex(1)
                
           /*
                if showChart {
                    FinanceChartView(transactions: transactions)
                        .padding()
                }
             */
                Spacer()
                List(transactions, id: \.id) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.category ?? "Unknown Category")
                            .font(.headline)
                        Text(transaction.date ?? Date(), style: .date)
                            .font(.subheadline)
                        Text("\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.type == "income" ? .green : .red)
                    }
                }
                
                NavigationLink(destination: AddTransactionView()) {
                    Text("Add Transaction")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Transactions")
        }
    }
}
