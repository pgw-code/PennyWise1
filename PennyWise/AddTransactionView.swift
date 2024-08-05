import SwiftUI
import CoreData

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var category = ""
    @State private var amount = ""
    @State private var type = TransactionType.expense
    @State private var date = Date()

    var body: some View {
        VStack {
            TextField("Category", text: $category)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Type", selection: $type) {
                ForEach(TransactionType.allCases, id: \.self) { value in
                    Text(value.rawValue.capitalized).tag(value)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            DatePicker("Date", selection: $date, displayedComponents: .date)
                .padding()

            Button(action: saveTransaction) {
                Text("Save Transaction")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Add Transaction")
    }

    private func saveTransaction() {
        guard let amountValue = Double(amount) else {
            // Handle invalid amount input
            return
        }
        
        let newTransaction = Transaction(context: viewContext)
        if let existingBudget = fetchBudget(for: category, in: viewContext) {
                // Update the budget's total spent amount
                existingBudget.totalSpent += amountValue
                print("Updated budget for category '\(category)' with new total spent: \(existingBudget.totalSpent)")
            } else {
                print("No matching budget found for category '\(category)'.")
            }
        newTransaction.category = category
        newTransaction.amount = amountValue
        newTransaction.type = type.rawValue
        newTransaction.date = date

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving transaction: \(error.localizedDescription)")
        }
    }
}

enum TransactionType: String, CaseIterable {
    case income, expense
}
