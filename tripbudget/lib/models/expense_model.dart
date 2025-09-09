import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpenseCategory {
  food,
  transportation,
  accommodation,
  entertainment,
  shopping,
  medical,
  miscellaneous,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food & Dining';
      case ExpenseCategory.transportation:
        return 'Transportation';
      case ExpenseCategory.accommodation:
        return 'Accommodation';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.medical:
        return 'Medical';
      case ExpenseCategory.miscellaneous:
        return 'Miscellaneous';
    }
  }

  String get iconName {
    switch (this) {
      case ExpenseCategory.food:
        return 'restaurant';
      case ExpenseCategory.transportation:
        return 'directions_car';
      case ExpenseCategory.accommodation:
        return 'hotel';
      case ExpenseCategory.entertainment:
        return 'movie';
      case ExpenseCategory.shopping:
        return 'shopping_bag';
      case ExpenseCategory.medical:
        return 'local_hospital';
      case ExpenseCategory.miscellaneous:
        return 'category';
    }
  }
}

class ExpenseModel {
  final String expenseId;
  final String userId;
  final String tripId;
  final double amount;
  final ExpenseCategory category;
  final DateTime expenseDate;
  final String? notes;
  final String? receiptImageUrl;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseModel({
    required this.expenseId,
    required this.userId,
    required this.tripId,
    required this.amount,
    required this.category,
    required this.expenseDate,
    this.notes,
    this.receiptImageUrl,
    this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert ExpenseModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'userId': userId,
      'tripId': tripId,
      'amount': amount,
      'category': category.name,
      'expenseDate': Timestamp.fromDate(expenseDate),
      'notes': notes,
      'receiptImageUrl': receiptImageUrl,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create ExpenseModel from Firestore document
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expenseId: map['expenseId'] ?? '',
      userId: map['userId'] ?? '',
      tripId: map['tripId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ExpenseCategory.miscellaneous,
      ),
      expenseDate: (map['expenseDate'] as Timestamp).toDate(),
      notes: map['notes'],
      receiptImageUrl: map['receiptImageUrl'],
      location: map['location'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create ExpenseModel from Firestore DocumentSnapshot
  factory ExpenseModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ExpenseModel.fromMap(data);
  }

  // Copy with method for updating expense data
  ExpenseModel copyWith({
    String? expenseId,
    String? userId,
    String? tripId,
    double? amount,
    ExpenseCategory? category,
    DateTime? expenseDate,
    String? notes,
    String? receiptImageUrl,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      expenseDate: expenseDate ?? this.expenseDate,
      notes: notes ?? this.notes,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(expenseId: $expenseId, amount: $amount, category: ${category.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseModel && other.expenseId == expenseId;
  }

  @override
  int get hashCode => expenseId.hashCode;
}
