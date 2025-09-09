class CityModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String country;
  final int population;
  final List<String> attractions;
  final bool isActive;

  CityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.population,
    this.attractions = const [],
    this.isActive = true,
  });

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      country: map['country'] ?? '',
      population: map['population'] ?? 0,
      attractions: List<String>.from(map['attractions'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'population': population,
      'attractions': attractions,
      'isActive': isActive,
    };
  }

  CityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? country,
    int? population,
    List<String>? attractions,
    bool? isActive,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      population: population ?? this.population,
      attractions: attractions ?? this.attractions,
      isActive: isActive ?? this.isActive,
    );
  }
} 