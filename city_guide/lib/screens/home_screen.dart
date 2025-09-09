import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../models/city_model.dart';
import '../models/attraction_model.dart';
import '../utils/constants.dart';
import '../widgets/attraction_card.dart';

class HomeScreen extends StatefulWidget {
  final String cityId;

  const HomeScreen({super.key, required this.cityId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CityModel? _city;
  List<AttractionModel> _attractions = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Tourist Attraction',
    'Restaurant',
    'Hotel',
    'Event',
    'Museum',
    'Park',
    'Shopping',
    'Entertainment',
    'Historical',
    'Nature',
  ];

  @override
  void initState() {
    super.initState();
    _loadCityAndAttractions();
  }

  Future<void> _loadCityAndAttractions() async {
    try {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      
      // Load city data
      final city = await databaseService.getCityById(widget.cityId);
      
      // Load attractions
      final attractions = await databaseService.getAttractionsByCity(widget.cityId);
      
      setState(() {
        _city = city;
        _attractions = attractions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  List<AttractionModel> get _filteredAttractions {
    if (_selectedCategory == 'All') {
      return _attractions;
    }
    return _attractions.where((attraction) {
      return attraction.category.toString().split('.').last == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_city == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('City Not Found'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: Text('City not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_city!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.go('/map/${widget.cityId}'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCityAndAttractions,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // City Header
              _buildCityHeader(),
              
              // Category Filter
              _buildCategoryFilter(),
              
              // Attractions Section
              _buildAttractionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          // City Image
          CachedNetworkImage(
            imageUrl: _city!.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.divider,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.divider,
              child: const Icon(
                Icons.location_city,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // City Info
          Positioned(
            bottom: AppConstants.paddingMedium,
            left: AppConstants.paddingMedium,
            right: AppConstants.paddingMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _city!.name,
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.surface,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _city!.country,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_attractions.length} attractions',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Container(
            margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.surface : AppColors.textPrimary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttractionsSection() {
    if (_filteredAttractions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.place_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                _selectedCategory == 'All'
                    ? 'No attractions available'
                    : 'No ${_selectedCategory.toLowerCase()} attractions',
                style: AppTextStyles.headline4.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Text(
            'Attractions',
            style: AppTextStyles.headline3,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          itemCount: _filteredAttractions.length,
          itemBuilder: (context, index) {
            final attraction = _filteredAttractions[index];
            return AttractionCard(
              attraction: attraction,
              onTap: () => context.go('/attraction/${attraction.id}'),
            );
          },
        ),
      ],
    );
  }
}