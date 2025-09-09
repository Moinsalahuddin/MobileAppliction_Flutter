# City Guide - Flutter App

A comprehensive mobile application designed to provide residents and tourists with valuable information and recommendations for exploring and enjoying cities. The app serves as a user-friendly, all-in-one solution for discovering local attractions, restaurants, events, accommodations, and more.

## Features

### 🔐 User Authentication
- User registration and login
- Password reset functionality
- Secure authentication with Firebase Auth

### 🏙️ City Selection
- Browse and select from available cities
- City information with descriptions and images
- Search functionality for cities

### 🎯 Attraction Management
- Comprehensive attraction listings
- Filter and sort by categories (restaurants, hotels, museums, etc.)
- Detailed attraction information including:
  - Images and descriptions
  - Contact information and opening hours
  - User ratings and reviews
  - Location and directions

### 🗺️ Maps and Navigation
- Integrated Google Maps
- Attraction markers on map
- Directions from current location
- Interactive map interface

### ⭐ Reviews and Ratings
- User reviews with star ratings
- Review management system
- Like helpful reviews
- Review moderation

### 🔍 Search and Discovery
- Search attractions by name or keywords
- Advanced filtering options
- Category-based browsing
- Location-based recommendations

### 👤 User Profiles
- Personal profile management
- Favorite attractions tracking
- Review history
- Profile customization

### 🛠️ Admin Dashboard
- Comprehensive admin panel
- Attraction management (add, edit, delete)
- User management
- Content moderation
- Analytics and statistics

## Technical Stack

### Frontend
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language
- **Provider** - State management
- **Go Router** - Navigation and routing

### Backend & Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Google Maps API** - Maps and location services

### UI/UX
- **Material Design** - Design system
- **Custom Theme** - Branded color scheme
- **Responsive Design** - Adaptive layouts
- **Loading States** - User feedback

## Project Structure

```
lib/
├── models/                 # Data models
│   ├── user_model.dart
│   ├── city_model.dart
│   ├── attraction_model.dart
│   └── review_model.dart
├── services/              # Business logic
│   ├── auth_service.dart
│   ├── database_service.dart
│   └── location_service.dart
├── screens/               # UI screens
│   ├── auth/             # Authentication screens
│   ├── city/             # City-related screens
│   ├── attraction/       # Attraction screens
│   ├── profile/          # User profile screens
│   └── admin/            # Admin screens
├── widgets/              # Reusable components
│   └── attraction_card.dart
├── utils/                # Utilities and constants
│   └── constants.dart
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd city_guide
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Enable Authentication, Firestore, and Storage
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Configure Firebase in your project

4. **Google Maps Setup**
   - Get Google Maps API key
   - Configure API key in Android and iOS configurations

5. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable the following services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Storage
3. Download configuration files and add them to your project

### Google Maps API
1. Get API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android and iOS
3. Add API key to your project configuration

## Features Implementation

### Authentication Flow
- Registration with email and password
- Login with existing credentials
- Password reset via email
- Session management

### Data Models
- **UserModel**: User profile and preferences
- **CityModel**: City information and metadata
- **AttractionModel**: Attraction details and categorization
- **ReviewModel**: User reviews and ratings

### State Management
- Provider pattern for state management
- Centralized auth state
- Reactive UI updates

### Navigation
- Go Router for declarative routing
- Deep linking support
- Route guards for authentication

## Admin Features

### Dashboard
- Overview of app statistics
- Quick access to management tools
- User activity monitoring

### Content Management
- Add/edit/delete attractions
- Manage city information
- Moderate user reviews
- User management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

## Future Enhancements

- Push notifications
- Offline mode support
- Social media integration
- Advanced analytics
- Multi-language support
- AR features for attraction discovery
- Booking integration for hotels and restaurants
