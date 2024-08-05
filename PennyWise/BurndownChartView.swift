import SwiftUI
import CoreData
import Charts

struct BurndownChartView: View {
    @ObservedObject var budget: BudgetEntity
    @Environment(\.managedObjectContext) private var viewContext
    @State private var transactions: [Transaction] = []
    @State private var fetchError: Error?
    @State private var showDetails = false
    @State private var showBudgetInput = false  // State to show/hide BudgetInputView

    var body: some View {
        VStack {
            // Toggle button for budget burndown details
            Button(action: {
                showDetails.toggle()
            }) {
                Text(showDetails ? "Hide Details" : "Show Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            
            if showDetails {
                VStack {
                    Text("Initial Budget: \(budget.initialAmount, specifier: "%.2f")")
                        .font(.headline)
                    Text("Total Spent: \(totalSpent, specifier: "%.2f")")
                        .font(.headline)
                    Text("Remaining Budget: \(remainingBudget, specifier: "%.2f")")
                        .font(.headline)
                    
                    Button(action: {
                        showBudgetInput = true
                    }) {
                        Text("Modify Budget")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
            }
            
            Chart {
                BarMark(
                    x: .value("Initial Budget", "Initial"),
                    y: .value("Amount", budget.initialAmount)
                )
                .foregroundStyle(Color.gray)
                
                BarMark(
                    x: .value("Spent", "Spent"),
                    y: .value("Amount", budget.totalSpent)
                )
                .foregroundStyle(Color.red)
                
                BarMark(
                    x: .value("Remaining", "Remaining"),
                    y: .value("Amount", remainingBudget)
                )
                .foregroundStyle(Color.green)
            }
            .frame(height: 300)
            .padding()
            
            if let error = fetchError {
                Text("Failed to fetch transactions: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(transactions, id: \.id) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.category ?? "Unknown Category")
                            .font(.headline)
                        Text(transaction.date ?? Date(), style: .date)
                            .font(.subheadline)
                        Text("\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.type == "expense" ? .red : .black)
                    }
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
        .navigationTitle("Burndown Chart")
        .sheet(isPresented: $showBudgetInput) {
            if let budget = try? viewContext.existingObject(with: budget.objectID) as? BudgetEntity {
                    BudgetInputView(budget: budget, context: viewContext)
                        .environment(\.managedObjectContext, viewContext)
                } else {
                //    BudgetInputView(budget: nil, context: viewContext)
                //        .environment(\.managedObjectContext, viewContext)
                }
        }
        .onAppear(perform: fetchTransactions)
    }
    
    private var totalSpent: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    private var remainingBudget: Double {
        budget.initialAmount - totalSpent
    }

    private func fetchTransactions() {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        
        // Assuming the Transaction entity has a 'budgetCategory' attribute or a relationship with BudgetEntity
        // Uncomment and modify the line below as per your actual model
        // request.predicate = NSPredicate(format: "budget == %@", budget)

        do {
            transactions = try viewContext.fetch(request)
        } catch {
            fetchError = error
        }
    }
}
