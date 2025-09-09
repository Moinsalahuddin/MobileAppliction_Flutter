import 'package:flutter/material.dart';
import 'dashboard_tab.dart';
import 'trips_tab.dart';
import 'expenses_tab.dart';
import 'profile_tab.dart';

class TravelColors {
  static const Color background = Color(0xFFF5F6F6);
  static const Color primaryText = Color(0xFF111111);
  static const Color secondaryText = Color(0xFF222222);
  static const Color primaryOrange = Color(0xFFFF7A00);
  static const Color inactiveGrey = Color(0xFF9E9E9E);
  static const Color cardWhite = Color(0xFFFFFFFF);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const DashboardTab(),
    const TripsTab(),
    const ExpensesTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: TravelColors.primaryOrange,
        unselectedItemColor: TravelColors.inactiveGrey,
        backgroundColor: TravelColors.cardWhite,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_takeoff),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
