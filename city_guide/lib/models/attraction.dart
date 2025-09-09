import 'package:cloud_firestore/cloud_firestore.dart';

class Attraction {
  final String id;
  final String name;
  final String cityId;
  final String description;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int reviewCount;
  final String address;
  final String phone;
  final String website;
  final Map<String, String> openingHours;
  final GeoPoint location;

  Attraction({
    required this.id,
    required this.name,
    required this.cityId,
    required this.description,
    required this.imageUrls,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.address,
    required this.phone,
    required this.website,
    required this.openingHours,
    required this.location,
  });

  // Add fromMap and toMap methods for Firestore integration
}