# PennyWise

PennyWise is a budgeting app designed to help users manage their finances by tracking transactions and budgets. The app allows users to add transactions, view expenses, and see a chart representation of their financial data. It also provides a burndown chart to visualize budget consumption over time.

## Features

- **Transaction Management**: Add, edit, and delete transactions with categories and amounts.
- **Budget Tracking**: Set budgets for different categories and track spending against these budgets.
- **Chart Visualization**: Visualize transactions and budget data with charts.
- **User-friendly Interface**: Simple and intuitive UI for easy navigation and management.

## Installation

To run PennyWise on your local machine, follow these steps:

1. **Clone the repository**:
   \`\`\`bash
   git clone https://github.com/pgw-code/PennyWise.git
   \`\`\`

2. **Navigate to the project directory**:
   \`\`\`bash
   cd PennyWise
   \`\`\`

3. **Open the project in Xcode**:
   - Double-click on \`PennyWise.xcodeproj\` or open Xcode and select the project.

4. **Build and run the app**:
   - Select a simulator or a connected device.
   - Press \`Cmd+R\` or click the play button to build and run the app.

## Usage

1. **Add Transactions**:
   - Use the "Add Transaction" button to add a new transaction.
   - Fill in the transaction details, including category and amount.

2. **View Transactions**:
   - The main screen lists all transactions, showing category, date, and amount.

3. **Toggle Chart Visibility**:
   - Use the "Show Chart" button to display a graphical representation of the transaction data.
   - Use the "Hide Chart" button to hide the chart.

4. **Manage Budgets**:
   - Navigate to the budget section to set or edit budgets for different categories.
   - View a burndown chart to see the budget consumption over time.

## Project Structure

- \`PennyWise/\`: Contains the main source code for the app.
  - \`Models/\`: Core Data models and entities.
  - \`Views/\`: SwiftUI views, including transaction and budget views.
  - \`ViewModels/\`: ViewModels for managing state and business logic.
- \`Resources/\`: Assets and other resources used in the app.

## Contributing

Contributions are welcome! If you have any suggestions or improvements, please:

1. Fork the repository.
2. Create a new branch (\`git checkout -b feature/YourFeature\`).
3. Commit your changes (\`git commit -m 'Add some feature'\`).
4. Push to the branch (\`git push origin feature/YourFeature\`).
5. Open a pull request.

## License

This project is licensed under the MIT License 

## Acknowledgments

- **SwiftUI**: For providing a modern UI framework.
- **Core Data**: For persistent data storage.
