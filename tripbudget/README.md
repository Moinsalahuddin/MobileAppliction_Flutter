# TripBudget - Travel Expense Tracker

A comprehensive Flutter mobile application for tracking travel expenses with Firebase backend integration.

## 🚀 Features

### User Management
- **User Registration & Login**: Secure authentication with Firebase Auth
- **Profile Management**: User profile with personal information
- **Password Reset**: Email-based password recovery

### Trip Management
- **Create Trips**: Add new trips with destination, dates, and budget
- **Trip Dashboard**: View active, upcoming, and completed trips
- **Trip Details**: Detailed view with budget tracking and expense breakdown
- **Budget Monitoring**: Real-time budget utilization with visual indicators

### Expense Tracking
- **Add Expenses**: Quick expense entry with categories and notes
- **Expense Categories**: Pre-defined categories (Food, Transportation, Accommodation, etc.)
- **Date & Location**: Track when and where expenses occurred
- **Real-time Updates**: Automatic budget calculations and trip totals

### Dashboard & Analytics
- **Overview Dashboard**: Quick stats and active trip summaries
- **Budget Visualization**: Progress indicators and remaining budget alerts
- **Expense History**: Chronological expense listing with filtering

## 🛠 Technical Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication (Firebase Auth)
  - Database (Cloud Firestore)
  - Storage (Firebase Storage)
- **State Management**: Provider
- **UI Components**: Material Design 3

## 📱 Screenshots & Demo

The app features a modern, intuitive interface with:
- Clean login/registration screens
- Comprehensive dashboard with trip overview
- Easy trip creation and management
- Quick expense entry with category selection
- Beautiful budget visualization with progress indicators

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tripbudget
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Enable Firebase Storage
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup Details

1. **Authentication**
   - Enable Email/Password sign-in method
   - Configure authorized domains if needed

2. **Firestore Database**
   - Create database in production mode
   - Set up security rules for user data protection

3. **Storage**
   - Enable Firebase Storage for profile images and receipts

## 📊 Database Structure

### Collections

**Users Collection (`users`)**
```
{
  userId: string,
  email: string,
  firstName: string,
  lastName: string,
  profileImageUrl?: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Trips Collection (`trips`)**
```
{
  tripId: string,
  userId: string,
  tripName: string,
  startDate: timestamp,
  endDate: timestamp,
  destination: string,
  budget: number,
  totalExpenses: number,
  description?: string,
  imageUrl?: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Expenses Collection (`expenses`)**
```
{
  expenseId: string,
  userId: string,
  tripId: string,
  amount: number,
  category: string,
  expenseDate: timestamp,
  notes?: string,
  receiptImageUrl?: string,
  location?: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## 🏗 Project Structure

```
lib/
├── models/
│   ├── user_model.dart
│   ├── trip_model.dart
│   └── expense_model.dart
├── services/
│   ├── auth_service.dart
│   └── database_service.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── dashboard_tab.dart
│   │   ├── trips_tab.dart
│   │   ├── expenses_tab.dart
│   │   └── profile_tab.dart
│   ├── trips/
│   │   ├── create_trip_screen.dart
│   │   └── trip_detail_screen.dart
│   └── expenses/
│       └── add_expense_screen.dart
├── firebase_options.dart
└── main.dart
```

## ✨ Key Features Implementation

### Authentication Flow
- Automatic login state management
- Secure user session handling
- Password validation and reset functionality

### Real-time Data Sync
- Live updates using Firestore streams
- Automatic budget calculations
- Instant expense tracking updates

### Modern UI/UX
- Material Design 3 components
- Responsive design for different screen sizes
- Intuitive navigation with bottom tabs
- Visual budget indicators and progress bars

### Data Management
- Efficient Firestore queries with proper indexing
- Batch operations for data consistency
- Error handling and user feedback

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## 🔮 Future Enhancements

- **Offline Support**: Local data caching for offline usage
- **Receipt Scanning**: OCR integration for automatic expense entry
- **Multi-currency Support**: Currency conversion and localization
- **Expense Reports**: PDF generation and export functionality
- **Social Features**: Trip sharing and collaborative budgeting
- **Analytics**: Advanced spending analytics and insights
- **Notifications**: Budget alerts and trip reminders

## 📄 License

This project is developed as part of a Flutter assessment and is available for educational purposes.

## 👨‍💻 Developer

Built with ❤️ using Flutter and Firebase

---

**Note**: Remember to configure your Firebase project settings in `firebase_options.dart` before running the application.
