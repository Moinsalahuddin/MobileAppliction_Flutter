import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  User? get currentUser => _user;

  AuthService() {
    _init();
  }

  Future<void> _init() async {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Register user
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user model
        UserModel userModel = UserModel(
          id: result.user!.uid,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          favoriteAttractions: [],
          isAdmin: false,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Save user data to Firestore
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(result.user!.uid)
            .set(userModel.toMap());

        // Save user token to shared preferences
        await _saveUserToken(result.user!.uid);

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Login user
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Get user data from Firestore
        DocumentSnapshot doc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(result.user!.uid)
            .get();

        if (doc.exists) {
          UserModel userModel = UserModel.fromMap({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });

          // Update last login time
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(result.user!.uid)
              .update({
            'lastLoginAt': DateTime.now().toIso8601String(),
          });

          // Save user token to shared preferences
          await _saveUserToken(result.user!.uid);

          return userModel;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      await _clearUserToken();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      
      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      
      updateData['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(updateData);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Toggle favorite attraction
  Future<void> toggleFavoriteAttraction({
    required String userId,
    required String attractionId,
  }) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        List<String> favorites = List<String>.from(
          (doc.data() as Map<String, dynamic>)['favoriteAttractions'] ?? [],
        );

        if (favorites.contains(attractionId)) {
          favorites.remove(attractionId);
        } else {
          favorites.add(attractionId);
        }

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({
          'favoriteAttractions': favorites,
        });
      }
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Save user token to shared preferences
  Future<void> _saveUserToken(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userIdKey, userId);
  }

  // Clear user token from shared preferences
  Future<void> _clearUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return AppConstants.authError;
    }
  }
}