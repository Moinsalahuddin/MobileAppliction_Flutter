import 'package:flutter/material.dart';

class TravelColors {
  static const Color background = Color(0xFFF5F6F6);
  static const Color primaryText = Color(0xFF111111);
  static const Color secondaryText = Color(0xFF222222);
  static const Color primaryOrange = Color(0xFFFF7A00);
  static const Color inactiveGrey = Color(0xFF9E9E9E);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color ratingOrange = Color(0xFFFFB800);
}

class TravelHomeScreen extends StatefulWidget {
  const TravelHomeScreen({super.key});

  @override
  State<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen> {
  final List<Map<String, dynamic>> countries = [
    {'name': 'Germany', 'flag': '🇩🇪', 'selected': true},
    {'name': 'France', 'flag': '🇫🇷', 'selected': false},
    {'name': 'Italy', 'flag': '🇮🇹', 'selected': false},
    {'name': 'Spain', 'flag': '🇪🇸', 'selected': false},
    {'name': 'Japan', 'flag': '🇯🇵', 'selected': false},
    {'name': 'USA', 'flag': '🇺🇸', 'selected': false},
  ];

  final List<Map<String, dynamic>> popularDestinations = [
    {
      'name': 'Santorini',
      'country': 'Greece',
      'rating': 4.8,
      'description': 'Beautiful island with stunning sunsets and white-washed buildings overlooking the Aegean Sea.',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&h=300&fit=crop',
      'reviews': 2847,
    },
    {
      'name': 'Bali',
      'country': 'Indonesia',
      'rating': 4.9,
      'description': 'Tropical paradise with pristine beaches, ancient temples, and lush rice terraces.',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400&h=300&fit=crop',
      'reviews': 3542,
    },
    {
      'name': 'Machu Picchu',
      'country': 'Peru',
      'rating': 4.7,
      'description': 'Ancient Inca citadel high in the Andes Mountains, one of the New Seven Wonders of the World.',
      'image': 'https://images.unsplash.com/photo-1587595431973-160d0d94add1?w=400&h=300&fit=crop',
      'reviews': 1934,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(),
            
            // Search Bar
            _buildSearchBar(),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Country Selector
                    _buildCountrySelector(),
                    
                    const SizedBox(height: 30),
                    
                    // Popular Destinations
                    _buildPopularDestinations(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.5),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=face'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Location Dropdown
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Handle location selection
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: TravelColors.primaryOrange, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Berlin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: TravelColors.primaryText,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, color: TravelColors.inactiveGrey, size: 18),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Notification Icon
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.notifications_outlined, color: TravelColors.inactiveGrey),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Where do you want to go?',
            hintStyle: TextStyle(color: TravelColors.inactiveGrey),
            prefixIcon: Icon(Icons.search, color: TravelColors.inactiveGrey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Countries',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TravelColors.primaryText,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              final isSelected = country['selected'] as bool;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    for (var c in countries) {
                      c['selected'] = false;
                    }
                    countries[index]['selected'] = true;
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? TravelColors.primaryOrange : TravelColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        country['flag'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        country['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? TravelColors.cardWhite : TravelColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Popular Destinations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TravelColors.primaryText,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: popularDestinations.length,
          itemBuilder: (context, index) {
            final destination = popularDestinations[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: TravelColors.cardWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(destination['image'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: TravelColors.ratingOrange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    destination['rating'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destination['name'] as String,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: TravelColors.primaryText,
                                    ),
                                  ),
                                  Text(
                                    destination['country'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: TravelColors.inactiveGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${destination['reviews']} reviews',
                              style: TextStyle(
                                fontSize: 12,
                                color: TravelColors.inactiveGrey,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          destination['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: TravelColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to destination details
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TravelColors.primaryOrange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Show Details',
                              style: TextStyle(
                                color: TravelColors.cardWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
