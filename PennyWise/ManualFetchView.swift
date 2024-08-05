import SwiftUI
import CoreData

struct ManualFetchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var transactions: [Transaction] = []
    @State private var fetchError: Error?
    @State private var showChart = false
    @State private var selectedBudget: BudgetEntity?
    @State private var showBudgetInput = false  // State to show the budget input sheet

    @FetchRequest(
        entity: BudgetEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.category, ascending: true)]
    ) var budgets: FetchedResults<BudgetEntity>

    var body: some View {
        NavigationView {
            VStack {
                // Toggle Chart Button
                Button(action: {
                    showChart.toggle()
                    print("Button tapped, showChart is now \(showChart)")
                }) {
                    Text(showChart ? "Hide Chart" : "Show Chart")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .zIndex(2)
                
                Spacer()
                Spacer()
                // Display Chart if `showChart` is true
                if showChart {
                    FinanceChartView(transactions: transactions)
                        .padding()
                        .zIndex(1)
                        
                    Spacer()
                    Spacer()
                }
                Spacer()
                // Display Transactions List
                if let error = fetchError {
                    Text("Failed to fetch transactions: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text("Transactions")
                            .font(.headline)
                            .padding([.top, .leading])

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
                    }
                }

                // Display Budgets List
                VStack(alignment: .leading) {
                    Text("Budgets")
                        .font(.headline)
                        .padding([.top, .leading])

                    List {
                        ForEach(budgets) { budget in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(budget.category ?? "Unknown Category")
                                        .font(.headline)
                                    Text("Initial: \(budget.initialAmount, specifier: "%.2f")")
                                    Text("Spent: \(budget.totalSpent, specifier: "%.2f")")
                                    Text("Remaining: \(budget.initialAmount - budget.totalSpent, specifier: "%.2f")")
                                }
                                Spacer()
                                Button(action: {
                                    selectedBudget = budget
                                    showBudgetInput = true
                                }) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedBudget = budget
                                showBudgetInput = true
                            }
                        }
                        .onDelete(perform: deleteBudgets)
                    }
                }

                // Add Budget and Transaction Buttons
                VStack {
                    Button(action: {
                        selectedBudget = nil  // Clear any selected budget to add a new one
                        showBudgetInput = true
                    }) {
                        Text("Add Budget")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .padding()

                    NavigationLink(destination: AddTransactionView()) {
                        Text("Add Transaction")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .navigationTitle("PennyWise Overview")
            .onAppear(perform: fetchTransactions)
            .sheet(isPresented: $showBudgetInput) {
                if let selectedBudget = selectedBudget {
                        BudgetInputView(budget: selectedBudget, context: viewContext)
                            .environment(\.managedObjectContext, viewContext)
                    } else {
                        // Handle the case where there is no selected budget (e.g., for adding a new budget)
                        BudgetInputView(budget: nil, context: viewContext)
                            .environment(\.managedObjectContext, viewContext)
                    }
            }
        }
    }
    
    private func fetchTransactions() {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        
        do {
            transactions = try viewContext.fetch(request)
        } catch {
            fetchError = error
        }
    }
    
    private func deleteBudgets(offsets: IndexSet) {
        offsets.map { budgets[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
