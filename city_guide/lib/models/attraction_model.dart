enum AttractionCategory {
  touristAttraction,
  restaurant,
  hotel,
  event,
  museum,
  park,
  shopping,
  entertainment,
  historical,
  nature
}

class AttractionModel {
  final String id;
  final String name;
  final String description;
  final String cityId;
  final AttractionCategory category;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final String address;
  final String phoneNumber;
  final String website;
  final String openingHours;
  final double averageRating;
  final int totalReviews;
  final double priceRange; // 1-5 scale
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cityId,
    required this.category,
    this.imageUrls = const [],
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.phoneNumber = '',
    this.website = '',
    this.openingHours = '',
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.priceRange = 0.0,
    this.tags = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttractionModel.fromMap(Map<String, dynamic> map) {
    return AttractionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      cityId: map['cityId'] ?? '',
      category: AttractionCategory.values.firstWhere(
        (e) => e.toString() == 'AttractionCategory.${map['category']}',
        orElse: () => AttractionCategory.touristAttraction,
      ),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      website: map['website'] ?? '',
      openingHours: map['openingHours'] ?? '',
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      priceRange: (map['priceRange'] ?? 0.0).toDouble(),
      tags: List<String>.from(map['tags'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityId': cityId,
      'category': category.toString().split('.').last,
      'imageUrls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phoneNumber': phoneNumber,
      'website': website,
      'openingHours': openingHours,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'priceRange': priceRange,
      'tags': tags,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AttractionModel copyWith({
    String? id,
    String? name,
    String? description,
    String? cityId,
    AttractionCategory? category,
    List<String>? imageUrls,
    double? latitude,
    double? longitude,
    String? address,
    String? phoneNumber,
    String? website,
    String? openingHours,
    double? averageRating,
    int? totalReviews,
    double? priceRange,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttractionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cityId: cityId ?? this.cityId,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      priceRange: priceRange ?? this.priceRange,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 