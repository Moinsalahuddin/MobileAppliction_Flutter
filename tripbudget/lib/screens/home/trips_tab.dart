import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/trip_model.dart';
import '../trips/create_trip_screen.dart';
import '../trips/trip_detail_screen.dart';

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab> {
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  final dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Trips',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTripScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<TripModel>>(
        stream: databaseService.getUserTrips(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading trips',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          final trips = snapshot.data ?? [];

          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_takeoff,
                      size: 72, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No trips yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first trip to start tracking expenses',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTripScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Create Trip',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          // Group trips
          final activeTrips = trips.where((t) => t.isActive).toList();
          final upcomingTrips = trips.where((t) => t.isUpcoming).toList();
          final completedTrips = trips.where((t) => t.isCompleted).toList();

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (activeTrips.isNotEmpty) ...[
                  _buildSectionHeader('Active Trips', activeTrips.length),
                  const SizedBox(height: 12),
                  ...activeTrips.map((t) => _buildTripCard(t, context)),
                  const SizedBox(height: 24),
                ],
                if (upcomingTrips.isNotEmpty) ...[
                  _buildSectionHeader('Upcoming Trips', upcomingTrips.length),
                  const SizedBox(height: 12),
                  ...upcomingTrips.map((t) => _buildTripCard(t, context)),
                  const SizedBox(height: 24),
                ],
                if (completedTrips.isNotEmpty) ...[
                  _buildSectionHeader('Completed Trips', completedTrips.length),
                  const SizedBox(height: 12),
                  ...completedTrips.map((t) => _buildTripCard(t, context)),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTripScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(TripModel trip, BuildContext context) {
    final budgetUtilization = trip.budgetUtilization;
    final remainingBudget = trip.remainingBudget;

    Color statusColor;
    String statusText;

    if (trip.isActive) {
      statusColor = Colors.green;
      statusText = 'Active';
    } else if (trip.isUpcoming) {
      statusColor = Colors.orange;
      statusText = 'Upcoming';
    } else {
      statusColor = Colors.grey;
      statusText = 'Completed';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripDetailScreen(trip: trip),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.tripName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(statusText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Destination
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(trip.destination,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                ],
              ),
              const SizedBox(height: 12),

              // Dates + Duration
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${dateFormatter.format(trip.startDate)} - ${dateFormatter.format(trip.endDate)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  Text('${trip.durationInDays} days',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),

              // Budget Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBudgetRow('Budget',
                            currencyFormatter.format(trip.budget)),
                        _buildBudgetRow('Spent',
                            currencyFormatter.format(trip.totalExpenses)),
                        _buildBudgetRow(
                          'Remaining',
                          currencyFormatter.format(remainingBudget),
                          color: remainingBudget >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: budgetUtilization / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            budgetUtilization > 100
                                ? Colors.red
                                : budgetUtilization > 80
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                          strokeWidth: 6,
                        ),
                        Center(
                          child: Text(
                            '${budgetUtilization.toStringAsFixed(0)}%',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black,
              )),
        ],
      ),
    );
  }
}
