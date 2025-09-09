import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/expense_model.dart';
import '../../models/trip_model.dart';
import '../expenses/add_expense_screen.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  final dateFormatter = DateFormat('MMM dd, yyyy');
  String? _selectedTripId;

  // Theme colors
  final Color backgroundColor = const Color(0xFFF5F6F6);
  final Color primaryColor = const Color(0xFFFF7A00);
  final Color inactiveColor = const Color(0xFF9E9E9E);
  final Color textColor = const Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Expenses',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: textColor),
            onPressed: () {
              _showFilterDialog(context, databaseService, user.uid);
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedTripId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Filtered by trip',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedTripId = null;
                      });
                    },
                    child: Text(
                      'Clear Filter',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: StreamBuilder<List<ExpenseModel>>(
              stream: _selectedTripId != null
                  ? databaseService.getTripExpenses(_selectedTripId!)
                  : databaseService.getUserExpenses(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: inactiveColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading expenses',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final expenses = snapshot.data ?? [];

                if (expenses.isEmpty) {
                  return _buildEmptyState(context);
                }

                final groupedExpenses = _groupExpensesByDate(expenses);

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: groupedExpenses.length,
                    itemBuilder: (context, index) {
                      final date = groupedExpenses.keys.elementAt(index);
                      final dayExpenses = groupedExpenses[date]!;
                      final dayTotal = dayExpenses.fold<double>(
                        0,
                        (sum, expense) => sum + expense.amount,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  dateFormatter.format(date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  currencyFormatter.format(dayTotal),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...dayExpenses.map(
                            (expense) => _buildExpenseCard(expense),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: inactiveColor),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first expense to start tracking',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: inactiveColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<ExpenseModel>> _groupExpensesByDate(
    List<ExpenseModel> expenses,
  ) {
    final Map<DateTime, List<ExpenseModel>> grouped = {};

    for (final expense in expenses) {
      final date = DateTime(
        expense.expenseDate.year,
        expense.expenseDate.month,
        expense.expenseDate.day,
      );
      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(expense);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final key in sortedKeys) key: grouped[key]!};
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(expense.category),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          expense.category.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (expense.notes?.isNotEmpty ?? false)
              Text(
                expense.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (expense.location?.isNotEmpty ?? false)
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: inactiveColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      expense.location!,
                      style: TextStyle(color: inactiveColor, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormatter.format(expense.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryColor,
              ),
            ),
            Text(
              DateFormat.jm().format(expense.expenseDate),
              style: TextStyle(color: inactiveColor, fontSize: 12),
            ),
          ],
        ),
        onTap: () => _showExpenseDetails(context, expense),
      ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transportation:
        return Colors.blue;
      case ExpenseCategory.accommodation:
        return Colors.purple;
      case ExpenseCategory.entertainment:
        return Colors.pink;
      case ExpenseCategory.shopping:
        return Colors.green;
      case ExpenseCategory.medical:
        return Colors.red;
      case ExpenseCategory.miscellaneous:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transportation:
        return Icons.directions_car;
      case ExpenseCategory.accommodation:
        return Icons.hotel;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.medical:
        return Icons.local_hospital;
      case ExpenseCategory.miscellaneous:
        return Icons.category;
    }
  }

  void _showFilterDialog(
    BuildContext context,
    DatabaseService databaseService,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => StreamBuilder<List<TripModel>>(
        stream: databaseService.getUserTrips(userId),
        builder: (context, snapshot) {
          final trips = snapshot.data ?? [];

          return AlertDialog(
            title: const Text('Filter by Trip'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('All Expenses'),
                  leading: Radio<String?>(
                    value: null,
                    groupValue: _selectedTripId,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() => _selectedTripId = value);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ...trips.map(
                  (trip) => ListTile(
                    title: Text(trip.tripName),
                    subtitle: Text(trip.destination),
                    leading: Radio<String?>(
                      value: trip.tripId,
                      groupValue: _selectedTripId,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        setState(() => _selectedTripId = value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExpenseDetails(BuildContext context, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.category.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Amount: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(currencyFormatter.format(expense.amount)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dateFormatter.format(expense.expenseDate)),
              ],
            ),
            if (expense.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              const Text(
                'Notes: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(expense.notes!),
            ],
            if (expense.location?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              const Text(
                'Location: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(expense.location!),
            ],
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
