import SwiftUI
import CoreData
extension BudgetEntity {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}
struct BudgetsListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest for BudgetEntity
    @FetchRequest(
        entity: BudgetEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BudgetEntity.category, ascending: true)]
    ) var budgets: FetchedResults<BudgetEntity>
    
    @State private var showBudgetInput = false
    @State private var selectedBudget: BudgetEntity?

    var body: some View {
        NavigationView {
            List {
                ForEach(budgets, id: \.id) { budget in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(budget.category ?? "Unknown Category")
                                .font(.headline)
                            Text("Initial: \(budget.initialAmount, specifier: "%.2f")")
                            Text("Spent: \(budget.totalSpent, specifier: "%.2f")")
                            Text("Remaining: \(budget.initialAmount - budget.totalSpent, specifier: "%.2f")")
                        }
                        Spacer()
                        NavigationLink(destination: BurndownChartView(budget: budget)) {
                            Text("View Details")
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
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedBudget = nil
                        showBudgetInput = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showBudgetInput) {
                if let budget = selectedBudget {
                        BudgetInputView(budget: budget, context: viewContext)
                            .environment(\.managedObjectContext, viewContext)
                    } else {
                   //     BudgetInputView(budget: BudgetEntity(context: viewContext), context: viewContext)
                     //       .environment(\.managedObjectContext, viewContext)
                    }
            }
        }
    }
    
    private func deleteBudgets(at offsets: IndexSet) {
        for index in offsets {
            let budget = budgets[index]
            viewContext.delete(budget)
        }
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
