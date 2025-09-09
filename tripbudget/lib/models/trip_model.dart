import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String tripId;
  final String userId;
  final String tripName;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final double budget;
  final double totalExpenses;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  TripModel({
    required this.tripId,
    required this.userId,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.budget,
    this.totalExpenses = 0.0,
    this.description,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert TripModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'userId': userId,
      'tripName': tripName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'destination': destination,
      'budget': budget,
      'totalExpenses': totalExpenses,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create TripModel from Firestore document
  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      tripId: map['tripId'] ?? '',
      userId: map['userId'] ?? '',
      tripName: map['tripName'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      destination: map['destination'] ?? '',
      budget: (map['budget'] ?? 0.0).toDouble(),
      totalExpenses: (map['totalExpenses'] ?? 0.0).toDouble(),
      description: map['description'],
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create TripModel from Firestore DocumentSnapshot
  factory TripModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TripModel.fromMap(data);
  }

  // Get remaining budget
  double get remainingBudget => budget - totalExpenses;

  // Get budget utilization percentage
  double get budgetUtilization => budget > 0 ? (totalExpenses / budget) * 100 : 0;

  // Check if trip is active (current date is between start and end date)
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Check if trip is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    return now.isBefore(startDate);
  }

  // Check if trip is completed
  bool get isCompleted {
    final now = DateTime.now();
    return now.isAfter(endDate);
  }

  // Get trip duration in days
  int get durationInDays => endDate.difference(startDate).inDays + 1;

  // Copy with method for updating trip data
  TripModel copyWith({
    String? tripId,
    String? userId,
    String? tripName,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
    double? budget,
    double? totalExpenses,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      tripName: tripName ?? this.tripName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TripModel(tripId: $tripId, tripName: $tripName, destination: $destination, budget: $budget)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TripModel && other.tripId == tripId;
  }

  @override
  int get hashCode => tripId.hashCode;
}
