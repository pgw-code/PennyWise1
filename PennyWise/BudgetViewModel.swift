//
//  BudgetViewModel.swift
//  PennyWise
//
//  Created by Praveen Wadikar on 8/3/24.
//

import SwiftUI
import CoreData

struct BudgetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
    ) var transactions: FetchedResults<Transaction>
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.category ?? "Unknown Category")
                        .font(.headline)
                    Text(transaction.date ?? Foundation.Date(), style: .date)
                        .font(.subheadline)
                    Text("\(transaction.amount, specifier: "%.2f")")
                        .foregroundColor(transaction.type == "income" ? .green : .red)
                }
            }
            .onDelete(perform: deleteTransaction)
        }
        .navigationTitle("Budget Overview")
    }
    
    private func deleteTransaction(at offsets: IndexSet) {
        offsets.forEach { index in
            let transaction = transactions[index]
            viewContext.delete(transaction)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting transaction: \(error.localizedDescription)")
        }
    }
}
