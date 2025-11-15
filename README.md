# Expense Tracker iOS App

A modern, professional iOS expense tracking application built with Swift 6.2 and SwiftUI, designed for iOS 18.

![Platform](https://img.shields.io/badge/platform-iOS%2018.0%2B-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-green.svg)

## Features

### Core Functionality
- **Add & Manage Expenses**: Easily add, edit, and delete expenses with a beautiful form interface
- **Smart Categorization**: Pre-defined categories (Food, Transportation, Entertainment, Shopping, Bills, Other) with custom icons and colors
- **Advanced Filtering**: Filter expenses by date range, category, or search text
- **Data Persistence**: All data is automatically saved using UserDefaults

### Dashboard & Analytics
- **Interactive Dashboard**: View your spending at a glance with summary cards
- **Spending Analytics**:
  - Total expenses across all time or filtered period
  - Monthly spending totals
  - Top spending category
  - Daily average spending
- **Visual Breakdowns**: Category-based spending charts with percentages
- **Recent Expenses**: Quick view of your latest transactions

### User Experience
- **Modern UI**: Clean, professional interface following iOS design guidelines
- **Responsive Design**: Works perfectly on all iPhone and iPad screen sizes
- **Search Functionality**: Quickly find expenses by description, category, or amount
- **Date Filters**: Quick filters for Today, This Week, This Month, Last Month, This Year, or All Time
- **Custom Date Ranges**: Set your own start and end dates for precise filtering
- **Form Validation**: Real-time validation ensures data integrity
- **Export Options**: Export your expenses to CSV or JSON format

## Technical Details

### Architecture
- **MVVM Pattern**: Clean separation of concerns with Model-View-ViewModel architecture
- **SwiftUI**: Modern declarative UI framework
- **Type Safety**: Full Swift 6.2 type safety enforcement
- **Concurrency**: Uses `@MainActor` for safe UI updates

### Project Structure
```
ExpenseTracker/
├── ExpenseTracker/
│   ├── Models/
│   │   ├── Expense.swift              # Core expense data model
│   │   ├── Category.swift             # Category enum with UI properties
│   │   └── ExpenseFilter.swift        # Filtering logic
│   ├── ViewModels/
│   │   └── ExpenseViewModel.swift     # Business logic & state management
│   ├── Views/
│   │   ├── Dashboard/
│   │   │   ├── DashboardView.swift    # Main dashboard
│   │   │   ├── SummaryCardView.swift  # Summary cards component
│   │   │   └── SpendingChartView.swift # Category breakdown chart
│   │   ├── Expenses/
│   │   │   ├── ExpenseListView.swift  # List of all expenses
│   │   │   ├── ExpenseRowView.swift   # Individual expense row
│   │   │   ├── ExpenseFormView.swift  # Add/edit form
│   │   │   └── FilterView.swift       # Advanced filtering
│   │   └── Components/
│   │       ├── CategoryIcon.swift     # Reusable category icon
│   │       └── CustomButton.swift     # Styled button component
│   ├── Services/
│   │   ├── PersistenceManager.swift   # UserDefaults data storage
│   │   └── ExportManager.swift        # CSV/JSON export
│   └── Utilities/
│       ├── Extensions.swift           # Helpful extensions
│       └── Constants.swift            # App-wide constants
└── ExpenseTracker.xcodeproj
```

## Requirements

- iOS 18.0 or later
- Xcode 15.0 or later
- Swift 6.2

## Installation & Setup

### Option 1: Using Xcode (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AMelloul/expenses-tracker.git
   cd expenses-tracker
   ```

2. **Open in Xcode**:
   ```bash
   open ExpenseTracker/ExpenseTracker.xcodeproj
   ```

3. **Select your target device**:
   - Choose an iOS Simulator or connected device from the scheme menu
   - Recommended: iPhone 15 Pro or later for best experience

4. **Build and Run**:
   - Press `Cmd + R` or click the Play button
   - The app will compile and launch in the simulator/device

### Option 2: Using Command Line

```bash
# Navigate to the project
cd expenses-tracker/ExpenseTracker

# Build the project
xcodebuild -project ExpenseTracker.xcodeproj \
           -scheme ExpenseTracker \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Or use the simulator directly
xcrun simctl boot "iPhone 15 Pro"
xcodebuild -project ExpenseTracker.xcodeproj \
           -scheme ExpenseTracker \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
           clean build
```

## Usage Guide

### Adding an Expense

1. Navigate to the **Expenses** tab
2. Tap the **+** button in the top-right corner
3. Fill in the expense details:
   - **Amount**: Enter the expense amount (required)
   - **Category**: Select from pre-defined categories
   - **Description**: Add a brief description (required)
   - **Date**: Choose the expense date
4. Tap **Add Expense** to save

### Editing an Expense

1. In the Expenses list, tap on any expense to open it
2. Modify the desired fields
3. Tap **Update Expense** to save changes

**Alternative**: Long-press on an expense and select **Edit** from the context menu

### Deleting an Expense

- **Method 1**: Long-press on an expense and select **Delete**
- **Method 2**: Swipe left on an expense row and tap **Delete**

### Filtering Expenses

#### Quick Filters
1. Tap the filter icon (three horizontal lines) in the Expenses view
2. Select a quick filter:
   - Today
   - This Week
   - This Month
   - Last Month
   - This Year
   - All Time

#### Custom Filters
1. Open the filter menu
2. Select a **Category** to filter by (optional)
3. Set a **Start Date** and/or **End Date**
4. Tap **Apply Filters**

#### Search
Simply type in the search bar at the top of the Expenses list to search by:
- Description
- Category name
- Amount

### Exporting Data

1. Navigate to the **Dashboard** tab
2. Tap the export icon (square with arrow) in the top-right
3. Choose export format:
   - **CSV**: Comma-separated values (opens in Numbers, Excel, etc.)
   - **JSON**: Structured data format
4. Share or save the exported file

## Features Breakdown

### Data Persistence
All expenses are automatically saved to your device using UserDefaults. Your data persists across app launches and is stored locally on your device.

### Category System
Six pre-defined categories with unique icons and colors:
- 🍴 **Food** (Orange)
- 🚗 **Transportation** (Blue)
- 📺 **Entertainment** (Purple)
- 🛒 **Shopping** (Pink)
- 📄 **Bills** (Red)
- ⚫ **Other** (Gray)

### Validation
The app includes comprehensive input validation:
- Amount must be greater than 0
- Amount cannot exceed $1,000,000 (sanity check)
- Description cannot be empty
- All fields are type-safe

### Analytics Calculations
- **Total Expenses**: Sum of all filtered expenses
- **Monthly Total**: Sum of expenses in the current month
- **Top Category**: Category with highest spending in filtered period
- **Daily Average**: Total expenses divided by number of days in filtered period

## Screenshots & UI

### Dashboard View
- Summary cards showing key metrics
- Category breakdown chart with percentages
- Recent expenses list
- Export functionality

### Expenses View
- Searchable list of all expenses
- Filter indicator badge
- Quick add button
- Empty state for new users
- Pull to refresh (implicit in ScrollView)

### Form View
- Clean, intuitive input fields
- Live category preview
- Built-in date picker
- Validation error alerts

## Customization

### Changing Colors
Edit `ExpenseTracker/Utilities/Constants.swift` to customize the color scheme:

```swift
struct Colors {
    static let primary = Color(red: 0.2, green: 0.5, blue: 0.8) // Change this
    static let secondary = Color(red: 0.3, green: 0.7, blue: 0.9) // And this
    // ...
}
```

### Adding Categories
Edit `ExpenseTracker/Models/Category.swift`:

```swift
enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case transportation = "Transportation"
    // Add your new category here
    case newCategory = "New Category"

    var icon: String {
        switch self {
        // Add icon mapping
        case .newCategory:
            return "star.fill"
        // ...
        }
    }

    var color: Color {
        switch self {
        // Add color mapping
        case .newCategory:
            return Color.cyan
        // ...
        }
    }
}
```

## Troubleshooting

### Build Errors

**Issue**: "Module not found" or compilation errors
**Solution**:
- Clean the build folder: `Cmd + Shift + K`
- Delete derived data: `Cmd + Shift + K` then restart Xcode
- Ensure you're using Xcode 15+ with Swift 6.2 support

**Issue**: Deployment target mismatch
**Solution**:
- Check that your simulator/device is running iOS 18.0 or later
- Update the deployment target in project settings if needed

### Runtime Issues

**Issue**: Data not persisting
**Solution**:
- Check that you have storage space available
- Try resetting the simulator: `Device > Erase All Content and Settings`

**Issue**: Export not working
**Solution**:
- Ensure you grant file access permissions when prompted
- Check that you have write permissions to the destination

## Contributing

This is a demonstration project, but feel free to:
1. Fork the repository
2. Create a feature branch
3. Make your improvements
4. Submit a pull request

## Future Enhancements

Potential features for future versions:
- [ ] iCloud sync across devices
- [ ] Recurring expenses
- [ ] Budget tracking and alerts
- [ ] Multiple currency support
- [ ] Expense attachments (receipts)
- [ ] Advanced charts and visualizations
- [ ] Widget support
- [ ] Dark mode customization
- [ ] Custom categories
- [ ] Tags and labels

## License

This project is available under the MIT License. See LICENSE file for details.

## Acknowledgments

Built with:
- Swift 6.2
- SwiftUI
- iOS 18 SDK

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Made with ❤️ using Swift and SwiftUI**
