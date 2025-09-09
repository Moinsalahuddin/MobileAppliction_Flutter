# Firebase Setup Guide for City Guide App

## Prerequisites
- Firebase project created
- Flutter project ready
- Android Studio / VS Code

## Step 1: Firebase Project Setup

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Create a project"**
3. Enter project name: `city-guide-app`
4. Enable Google Analytics (optional)
5. Click **"Create project"**

### 1.2 Enable Required Services

#### Authentication
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. Click **"Save"**

#### Firestore Database
1. Go to **Firestore Database** → **Create database**
2. Choose **"Start in test mode"**
3. Select location (e.g., `us-central1`)
4. Click **"Done"**

#### Storage
1. Go to **Storage** → **Get started**
2. Choose **"Start in test mode"**
3. Select same location as Firestore
4. Click **"Done"**

## Step 2: Add Apps to Firebase

### 2.1 Android App
1. Click **"Add app"** → **Android**
2. Android package name: `com.example.city_guide`
3. App nickname: `City Guide Android`
4. Click **"Register app"**
5. Download `google-services.json`

### 2.2 iOS App
1. Click **"Add app"** → **iOS**
2. iOS bundle ID: `com.example.cityGuide`
3. App nickname: `City Guide iOS`
4. Click **"Register app"**
5. Download `GoogleService-Info.plist`

## Step 3: Configure Flutter App

### 3.1 Place Configuration Files
- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/`

### 3.2 Update iOS Configuration
1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click on Runner folder
3. Select **"Add Files to Runner"**
4. Choose `GoogleService-Info.plist`
5. Make sure it's added to the Runner target

### 3.3 Update iOS Info.plist
Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## Step 4: Firestore Security Rules

### 4.1 Basic Security Rules
Go to **Firestore Database** → **Rules** and set:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read cities and attractions
    match /cities/{cityId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    match /attractions/{attractionId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Users can create reviews, admins can manage all
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
    }
  }
}
```

### 4.2 Storage Security Rules
Go to **Storage** → **Rules** and set:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload profile images
    match /users/{userId}/profile.jpg {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Admins can upload attraction images
    match /attractions/{attractionId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null && 
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

## Step 5: Test Firebase Connection

### 5.1 Run the App
```bash
flutter pub get
flutter run
```

### 5.2 Test Authentication
1. Try to register a new user
2. Try to login with the registered user
3. Check Firebase Console → Authentication → Users

### 5.3 Test Firestore
1. Create some test data in Firestore
2. Check if the app can read the data
3. Verify collections: `users`, `cities`, `attractions`, `reviews`

## Step 6: Google Maps Setup

### 6.1 Get API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** → **Credentials**
4. Click **"Create Credentials"** → **API Key**

### 6.2 Enable Maps APIs
Enable these APIs:
- Maps SDK for Android
- Maps SDK for iOS
- Places API
- Geocoding API

### 6.3 Configure API Key

#### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY"/>
    </application>
</manifest>
```

#### iOS
Add to `ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Step 7: Sample Data

### 7.1 Create Sample Cities
```javascript
// In Firestore Console, create a document in 'cities' collection:
{
  id: "new-york",
  name: "New York City",
  description: "The Big Apple - a vibrant metropolis with endless attractions",
  imageUrl: "https://example.com/nyc.jpg",
  latitude: 40.7128,
  longitude: -74.0060,
  country: "United States",
  population: 8336817,
  attractions: [],
  isActive: true
}
```

### 7.2 Create Sample Attractions
```javascript
// In Firestore Console, create a document in 'attractions' collection:
{
  id: "statue-of-liberty",
  name: "Statue of Liberty",
  description: "Iconic symbol of freedom and democracy",
  cityId: "new-york",
  category: "touristAttraction",
  imageUrls: ["https://example.com/statue.jpg"],
  latitude: 40.6892,
  longitude: -74.0445,
  address: "Liberty Island, New York, NY 10004",
  phoneNumber: "+1-212-363-3200",
  website: "https://www.nps.gov/stli/",
  openingHours: "9:00 AM - 5:00 PM",
  averageRating: 4.5,
  totalReviews: 1250,
  priceRange: 3.0,
  tags: ["landmark", "monument", "history"],
  isActive: true,
  createdAt: "2024-01-01T00:00:00Z",
  updatedAt: "2024-01-01T00:00:00Z"
}
```

## Troubleshooting

### Common Issues
1. **Build errors**: Make sure `google-services.json` is in the correct location
2. **Authentication fails**: Check if Email/Password auth is enabled
3. **Firestore permission denied**: Update security rules
4. **Maps not loading**: Verify API key and enabled APIs

### Debug Commands
```bash
flutter clean
flutter pub get
flutter run --verbose
```

## Next Steps
1. Test all features thoroughly
2. Set up production security rules
3. Configure Firebase Analytics
4. Set up Firebase Crashlytics
5. Deploy to app stores 