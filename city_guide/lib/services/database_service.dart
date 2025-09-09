import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/city_model.dart';
import '../models/attraction_model.dart';
import '../models/review_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // City Operations
  Future<List<CityModel>> getCities() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.citiesCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => CityModel.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<CityModel?> getCityById(String cityId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.citiesCollection)
          .doc(cityId)
          .get();

      if (doc.exists) {
        return CityModel.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Attraction Operations
  Future<List<AttractionModel>> getAttractionsByCity(String cityId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attractionsCollection)
          .where('cityId', isEqualTo: cityId)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => AttractionModel.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<List<AttractionModel>> getAttractionsByCategory(
    String cityId,
    AttractionCategory category,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attractionsCollection)
          .where('cityId', isEqualTo: cityId)
          .where('category', isEqualTo: category.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => AttractionModel.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<AttractionModel?> getAttractionById(String attractionId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.attractionsCollection)
          .doc(attractionId)
          .get();

      if (doc.exists) {
        return AttractionModel.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<List<AttractionModel>> searchAttractions(
    String cityId,
    String query,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.attractionsCollection)
          .where('cityId', isEqualTo: cityId)
          .where('isActive', isEqualTo: true)
          .get();

      List<AttractionModel> attractions = snapshot.docs
          .map((doc) => AttractionModel.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      // Filter by name, description, or tags
      return attractions.where((attraction) {
        final searchLower = query.toLowerCase();
        return attraction.name.toLowerCase().contains(searchLower) ||
            attraction.description.toLowerCase().contains(searchLower) ||
            attraction.tags.any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Review Operations
  Future<List<ReviewModel>> getReviewsByAttraction(String attractionId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('attractionId', isEqualTo: attractionId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> addReview(ReviewModel review) async {
    try {
      await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(review.id)
          .set(review.toMap());

      // Update attraction's average rating
      await _updateAttractionRating(review.attractionId);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> updateReview(ReviewModel review) async {
    try {
      await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(review.id)
          .update(review.toMap());

      // Update attraction's average rating
      await _updateAttractionRating(review.attractionId);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> deleteReview(String reviewId, String attractionId) async {
    try {
      await _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(reviewId)
          .delete();

      // Update attraction's average rating
      await _updateAttractionRating(attractionId);
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> likeReview(String reviewId, String userId) async {
    try {
      DocumentReference reviewRef = _firestore
          .collection(AppConstants.reviewsCollection)
          .doc(reviewId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot reviewDoc = await transaction.get(reviewRef);
        
        if (reviewDoc.exists) {
          List<String> likedBy = List<String>.from(
            (reviewDoc.data() as Map<String, dynamic>)['likedBy'] ?? [],
          );

          if (likedBy.contains(userId)) {
            likedBy.remove(userId);
          } else {
            likedBy.add(userId);
          }

          transaction.update(reviewRef, {
            'likedBy': likedBy,
            'likes': likedBy.length,
          });
        }
      });
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Admin Operations
  Future<void> addAttraction(AttractionModel attraction) async {
    try {
      await _firestore
          .collection(AppConstants.attractionsCollection)
          .doc(attraction.id)
          .set(attraction.toMap());
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> updateAttraction(AttractionModel attraction) async {
    try {
      await _firestore
          .collection(AppConstants.attractionsCollection)
          .doc(attraction.id)
          .update(attraction.toMap());
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> deleteAttraction(String attractionId) async {
    try {
      await _firestore
          .collection(AppConstants.attractionsCollection)
          .doc(attractionId)
          .update({'isActive': false});
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> addCity(CityModel city) async {
    try {
      await _firestore
          .collection(AppConstants.citiesCollection)
          .doc(city.id)
          .set(city.toMap());
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> updateCity(CityModel city) async {
    try {
      await _firestore
          .collection(AppConstants.citiesCollection)
          .doc(city.id)
          .update(city.toMap());
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  Future<void> deleteCity(String cityId) async {
    try {
      await _firestore
          .collection(AppConstants.citiesCollection)
          .doc(cityId)
          .update({'isActive': false});
    } catch (e) {
      throw AppConstants.generalError;
    }
  }

  // Helper Methods
  Future<void> _updateAttractionRating(String attractionId) async {
    try {
      QuerySnapshot reviewsSnapshot = await _firestore
          .collection(AppConstants.reviewsCollection)
          .where('attractionId', isEqualTo: attractionId)
          .get();

      if (reviewsSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in reviewsSnapshot.docs) {
          totalRating += (doc.data() as Map<String, dynamic>)['rating'] ?? 0;
        }

        double averageRating = totalRating / reviewsSnapshot.docs.length;

        await _firestore
            .collection(AppConstants.attractionsCollection)
            .doc(attractionId)
            .update({
          'averageRating': averageRating,
          'totalReviews': reviewsSnapshot.docs.length,
        });
      }
    } catch (e) {
      // Silently handle rating update errors
    }
  }
}
