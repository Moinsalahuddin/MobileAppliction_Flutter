import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

// Firebase config
import 'firebase_options.dart'; // Make sure this file exists after running `flutterfire configure`

// Services
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/location_service.dart';

// Constants & UI
import 'utils/constants.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/city/city_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/attraction/attractions_list_screen.dart';
import 'screens/attraction/attraction_detail_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/attraction_management.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const CityGuideApp());
}

class CityGuideApp extends StatelessWidget {
  const CityGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => DatabaseService()),
        Provider(create: (_) => LocationService()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: _buildTheme(),
        routerConfig: _buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
          fontFamily: 'Poppins',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        color: AppColors.card,
      ),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const CitySelectionScreen(),
        ),
        GoRoute(
          path: '/home/:cityId',
          builder: (context, state) => HomeScreen(
            cityId: state.pathParameters['cityId']!,
          ),
        ),
        GoRoute(
          path: '/attractions/:cityId',
          builder: (context, state) => AttractionsListScreen(
            cityId: state.pathParameters['cityId']!,
          ),
        ),
        GoRoute(
          path: '/attraction/:attractionId',
          builder: (context, state) => AttractionDetailScreen(
            attractionId: state.pathParameters['attractionId']!,
          ),
        ),
        GoRoute(
          path: '/map/:cityId',
          builder: (context, state) => MapScreen(
            cityId: state.pathParameters['cityId']!,
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboard(),
        ),
        GoRoute(
          path: '/admin/attractions',
          builder: (context, state) => const AttractionManagement(),
        ),
      ],
      redirect: (context, state) {
        final authService = Provider.of<AuthService>(context, listen: false);
        final isAuthenticated = authService.isAuthenticated;

        if (!isAuthenticated &&
            !state.matchedLocation.startsWith('/login') &&
            !state.matchedLocation.startsWith('/register') &&
            !state.matchedLocation.startsWith('/reset-password') &&
            state.matchedLocation != '/') {
          return '/login';
        }

        if (isAuthenticated &&
            (state.matchedLocation.startsWith('/login') ||
             state.matchedLocation.startsWith('/register') ||
             state.matchedLocation.startsWith('/reset-password'))) {
          return '/';
        }

        return null;
      },
    );
  }
}
