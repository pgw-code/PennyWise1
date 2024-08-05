import SwiftUI
import CoreData
import Charts

struct BudgetDetailView: View {
    @ObservedObject var budget: BudgetEntity

    var body: some View {
        VStack {
            Text("\(budget.category ?? "Unknown Category") Budget")
                .font(.largeTitle)
                .padding()

            Chart {
                // Ensure initialAmount and spentAmount are Double and properly set in Core Data
                BarMark(
                    x: .value("Type", "Initial"),
                    y: .value("Amount", budget.initialAmount)
                )
                .foregroundStyle(Color.gray)

                BarMark(
                    x: .value("Type", "Spent"),
                    y: .value("Amount", budget.totalSpent)
                )
                .foregroundStyle(Color.red)

                BarMark(
                    x: .value("Type", "Remaining"),
                    y: .value("Amount", remainingAmount)
                )
                .foregroundStyle(Color.green)
            }
            .frame(height: 300)
            .padding()

            VStack(alignment: .leading) {
                Text("Initial Budget: \(budget.initialAmount, specifier: "%.2f")")
                Text("Total Spent: \(budget.totalSpent, specifier: "%.2f")")
                Text("Remaining Budget: \(remainingAmount, specifier: "%.2f")")
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    // Computed property to calculate remaining amount
    private var remainingAmount: Double {
        (budget.initialAmount as NSNumber).doubleValue - (budget.totalSpent as NSNumber).doubleValue
    }
}

