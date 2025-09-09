@echo off
echo ========================================
echo Firebase Setup for City Guide App
echo ========================================
echo.

echo 1. Create Firebase Project:
echo    - Go to https://console.firebase.google.com/
echo    - Click "Create a project"
echo    - Name: city-guide-app
echo    - Enable Google Analytics (optional)
echo.

echo 2. Enable Services:
echo    - Authentication: Email/Password
echo    - Firestore Database: Start in test mode
echo    - Storage: Start in test mode
echo.

echo 3. Add Android App:
echo    - Package name: com.example.city_guide
echo    - Download google-services.json
echo    - Place in android/app/
echo.

echo 4. Add iOS App:
echo    - Bundle ID: com.example.cityGuide
echo    - Download GoogleService-Info.plist
echo    - Place in ios/Runner/
echo.

echo 5. Get Google Maps API Key:
echo    - Go to https://console.cloud.google.com/
echo    - Select your Firebase project
echo    - APIs & Services > Credentials
echo    - Create API Key
echo    - Enable Maps SDK for Android/iOS
echo.

echo 6. Run these commands:
echo    flutter pub get
echo    flutter run
echo.

pause 