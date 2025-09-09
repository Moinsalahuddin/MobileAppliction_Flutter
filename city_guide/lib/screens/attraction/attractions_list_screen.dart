import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';
import '../../models/attraction_model.dart';
import '../../utils/constants.dart';
import '../../widgets/attraction_card.dart';

class AttractionsListScreen extends StatefulWidget {
  final String cityId;

  const AttractionsListScreen({super.key, required this.cityId});

  @override
  State<AttractionsListScreen> createState() => _AttractionsListScreenState();
}

class _AttractionsListScreenState extends State<AttractionsListScreen> {
  List<AttractionModel> _attractions = [];
  List<AttractionModel> _filteredAttractions = [];
  bool _isLoading = true;
  String _searchQuery = '';
  AttractionCategory? _selectedCategory;

  final List<AttractionCategory> _categories = AttractionCategory.values;

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    try {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      final attractions = await databaseService.getAttractionsByCity(widget.cityId);
      
      setState(() {
        _attractions = attractions;
        _filteredAttractions = attractions;
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

  void _filterAttractions() {
    setState(() {
      _filteredAttractions = _attractions.where((attraction) {
        bool matchesSearch = _searchQuery.isEmpty ||
            attraction.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            attraction.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            attraction.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
        
        bool matchesCategory = _selectedCategory == null ||
            attraction.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attractions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home/${widget.cityId}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterAttractions();
              },
              decoration: InputDecoration(
                hintText: 'Search attractions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                          _filterAttractions();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            child: Row(
              children: [
                Text(
                  '${_filteredAttractions.length} attractions found',
                  style: AppTextStyles.body2,
                ),
                if (_selectedCategory != null) ...[
                  const SizedBox(width: AppConstants.paddingSmall),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Text(
                      _getCategoryDisplayName(_selectedCategory!),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppConstants.paddingSmall),

          // Attractions List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredAttractions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                            Text(
                              _searchQuery.isEmpty && _selectedCategory == null
                                  ? 'No attractions available'
                                  : 'No attractions found',
                              style: AppTextStyles.headline4.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty || _selectedCategory != null) ...[
                              const SizedBox(height: AppConstants.paddingSmall),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTextStyles.body2,
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAttractions,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          itemCount: _filteredAttractions.length,
                          itemBuilder: (context, index) {
                            final attraction = _filteredAttractions[index];
                            return AttractionCard(
                              attraction: attraction,
                              onTap: () => context.go('/attraction/${attraction.id}'),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _categories.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: const Text('All Categories'),
                  leading: Radio<AttractionCategory?>(
                    value: null,
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                      _filterAttractions();
                      Navigator.pop(context);
                    },
                  ),
                );
              }
              
              final category = _categories[index - 1];
              return ListTile(
                title: Text(_getCategoryDisplayName(category)),
                leading: Radio<AttractionCategory?>(
                  value: category,
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    _filterAttractions();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
              });
              _filterAttractions();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(AttractionCategory category) {
    switch (category) {
      case AttractionCategory.touristAttraction:
        return 'Tourist Attraction';
      case AttractionCategory.restaurant:
        return 'Restaurant';
      case AttractionCategory.hotel:
        return 'Hotel';
      case AttractionCategory.event:
        return 'Event';
      case AttractionCategory.museum:
        return 'Museum';
      case AttractionCategory.park:
        return 'Park';
      case AttractionCategory.shopping:
        return 'Shopping';
      case AttractionCategory.entertainment:
        return 'Entertainment';
      case AttractionCategory.historical:
        return 'Historical';
      case AttractionCategory.nature:
        return 'Nature';
    }
  }
}