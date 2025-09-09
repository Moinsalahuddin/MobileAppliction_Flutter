import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';
import '../models/expense_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ----------------- TRIP OPERATIONS -----------------

  // Create a new trip
  Future<void> createTrip(TripModel trip) async {
    try {
      await _firestore
          .collection('trips')
          .doc(trip.tripId)
          .set(trip.toMap());
    } catch (e) {
      throw Exception('Failed to create trip: ${e.toString()}');
    }
  }

  // Get all trips for a user
  Stream<List<TripModel>> getUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<TripModel> trips = snapshot.docs
              .map((doc) => TripModel.fromSnapshot(doc))
              .toList();

          // ✅ Sort in memory
          trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return trips;
        });
  }

  // Get a specific trip
  Future<TripModel?> getTrip(String tripId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('trips').doc(tripId).get();

      if (doc.exists) {
        return TripModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get trip: ${e.toString()}');
    }
  }

  // Update trip
  Future<void> updateTrip(TripModel trip) async {
    try {
      await _firestore
          .collection('trips')
          .doc(trip.tripId)
          .update(trip.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw Exception('Failed to update trip: ${e.toString()}');
    }
  }

  // Delete trip (with expenses)
  Future<void> deleteTrip(String tripId) async {
    try {
      final expensesQuery = await _firestore
          .collection('expenses')
          .where('tripId', isEqualTo: tripId)
          .get();

      final batch = _firestore.batch();
      for (final doc in expensesQuery.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(_firestore.collection('trips').doc(tripId));
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete trip: ${e.toString()}');
    }
  }

  // ----------------- EXPENSE OPERATIONS -----------------

  // Create a new expense
  Future<void> createExpense(ExpenseModel expense) async {
    try {
      final batch = _firestore.batch();

      // Add expense
      batch.set(
        _firestore.collection('expenses').doc(expense.expenseId),
        expense.toMap(),
      );

      // Update trip's total expenses
      final tripRef = _firestore.collection('trips').doc(expense.tripId);
      batch.update(tripRef, {
        'totalExpenses': FieldValue.increment(expense.amount),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create expense: ${e.toString()}');
    }
  }

  // Get all expenses for a trip (sorted in memory)
  Stream<List<ExpenseModel>> getTripExpenses(String tripId) {
    return _firestore
        .collection('expenses')
        .where('tripId', isEqualTo: tripId)
        .snapshots()
        .map((snapshot) {
          List<ExpenseModel> expenses = snapshot.docs
              .map((doc) => ExpenseModel.fromSnapshot(doc))
              .toList();

          // ✅ Sort in memory
          expenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
          return expenses;
        });
  }

  // Get all expenses for a user (sorted in memory)
  Stream<List<ExpenseModel>> getUserExpenses(String userId) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<ExpenseModel> expenses = snapshot.docs
              .map((doc) => ExpenseModel.fromSnapshot(doc))
              .toList();

          // ✅ Sort in memory
          expenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
          return expenses;
        });
  }

  // Get expenses by category for a trip
  Future<Map<ExpenseCategory, double>> getTripExpensesByCategory(
      String tripId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('expenses')
          .where('tripId', isEqualTo: tripId)
          .get();

      final Map<ExpenseCategory, double> categoryTotals = {};

      for (final doc in snapshot.docs) {
        final expense = ExpenseModel.fromSnapshot(doc);
        categoryTotals[expense.category] =
            (categoryTotals[expense.category] ?? 0) + expense.amount;
      }

      return categoryTotals;
    } catch (e) {
      throw Exception('Failed to get expenses by category: ${e.toString()}');
    }
  }

  // Update expense
  Future<void> updateExpense(
      ExpenseModel oldExpense, ExpenseModel newExpense) async {
    try {
      final batch = _firestore.batch();

      // Update expense
      batch.update(
        _firestore.collection('expenses').doc(newExpense.expenseId),
        newExpense.copyWith(updatedAt: DateTime.now()).toMap(),
      );

      // Update trip's total expenses
      final tripRef = _firestore.collection('trips').doc(newExpense.tripId);
      final difference = newExpense.amount - oldExpense.amount;
      batch.update(tripRef, {
        'totalExpenses': FieldValue.increment(difference),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update expense: ${e.toString()}');
    }
  }

  // Delete expense
  Future<void> deleteExpense(ExpenseModel expense) async {
    try {
      final batch = _firestore.batch();

      batch.delete(_firestore.collection('expenses').doc(expense.expenseId));

      final tripRef = _firestore.collection('trips').doc(expense.tripId);
      batch.update(tripRef, {
        'totalExpenses': FieldValue.increment(-expense.amount),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete expense: ${e.toString()}');
    }
  }

  // ----------------- ANALYTICS & REPORTS -----------------

  // Get monthly expense summary for a user
  Future<Map<String, double>> getMonthlyExpenseSummary(
      String userId, int year) async {
    try {
      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(year + 1, 1, 1);

      final QuerySnapshot snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .where('expenseDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('expenseDate', isLessThan: Timestamp.fromDate(endDate))
          .get();

      final Map<String, double> monthlyTotals = {};

      for (final doc in snapshot.docs) {
        final expense = ExpenseModel.fromSnapshot(doc);
        final monthKey =
            '${expense.expenseDate.year}-${expense.expenseDate.month.toString().padLeft(2, '0')}';
        monthlyTotals[monthKey] =
            (monthlyTotals[monthKey] ?? 0) + expense.amount;
      }

      return monthlyTotals;
    } catch (e) {
      throw Exception('Failed to get monthly summary: ${e.toString()}');
    }
  }

  // Get total expenses for a user
  Future<double> getUserTotalExpenses(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        final expense = ExpenseModel.fromSnapshot(doc);
        total += expense.amount;
      }

      return total;
    } catch (e) {
      throw Exception('Failed to get total expenses: ${e.toString()}');
    }
  }
}
