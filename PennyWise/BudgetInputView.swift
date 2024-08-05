import SwiftUI
import CoreData
func fetchBudget(for category: String, in context: NSManagedObjectContext) -> BudgetEntity? {
    let fetchRequest: NSFetchRequest<BudgetEntity> = BudgetEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "category == %@", category)
    fetchRequest.fetchLimit = 1

    do {
        let results = try context.fetch(fetchRequest)
        return results.first
    } catch {
        print("Error fetching budget for category \(category): \(error)")
        return nil
    }
}

struct BudgetInputView: View {
    var budget: BudgetEntity?
    var context: NSManagedObjectContext
    
    @Environment(\.presentationMode) var presentationMode
    @State private var category: String = ""
    @State private var initialAmount: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Category", text: $category)
                TextField("Initial Amount", value: $initialAmount, formatter: NumberFormatter())
            }
            .navigationTitle(budget == nil ? "Add Budget" : "Edit Budget")
            .navigationBarItems(trailing: Button("Save") {
                if let budget = budget {
                    // Editing existing budget
                    budget.category = category
                    budget.initialAmount = initialAmount
                    print("Creating budget: \(budget)")
                } else {
                    // Creating new budget
                    let newBudget = BudgetEntity(context: context)
                    newBudget.id = UUID()
                    newBudget.category = category
                    newBudget.initialAmount = initialAmount
                    newBudget.totalSpent = 0
                    print("Creating a new budget: \(newBudget)")
                }
                saveContext()
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                if let budget = budget {
                    category = budget.category ?? ""
                    initialAmount = budget.initialAmount
                }
            }
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error saving context: \(nsError), \(nsError.userInfo)")
            // Handle the error appropriately in production
        }
    }
}
