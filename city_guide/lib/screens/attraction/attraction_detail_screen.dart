import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/database_service.dart';
import '../../services/auth_service.dart';
import '../../models/attraction_model.dart';
import '../../models/review_model.dart';
import '../../utils/constants.dart';

class AttractionDetailScreen extends StatefulWidget {
  final String attractionId;

  const AttractionDetailScreen({super.key, required this.attractionId});

  @override
  State<AttractionDetailScreen> createState() => _AttractionDetailScreenState();
}

class _AttractionDetailScreenState extends State<AttractionDetailScreen> {
  AttractionModel? _attraction;
  List<ReviewModel> _reviews = [];
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadAttractionDetails();
  }

  Future<void> _loadAttractionDetails() async {
    try {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Load attraction details
      final attraction = await databaseService.getAttractionById(widget.attractionId);
      
      // Load reviews
      final reviews = await databaseService.getReviewsByAttraction(widget.attractionId);
      
      // Check if user has favorited this attraction
      bool isFavorite = false;
      if (authService.isAuthenticated) {
        final user = await authService.getUserById(authService.currentUser!.uid);
        isFavorite = user?.favoriteAttractions.contains(widget.attractionId) ?? false;
      }
      
      setState(() {
        _attraction = attraction;
        _reviews = reviews;
        _isFavorite = isFavorite;
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

  Future<void> _toggleFavorite() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (!authService.isAuthenticated) {
        context.go('/login');
        return;
      }

      await authService.toggleFavoriteAttraction(
        userId: authService.currentUser!.uid,
        attractionId: widget.attractionId,
      );

      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open link'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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

    if (_attraction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Attraction Not Found'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: Text('Attraction not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image
                  CachedNetworkImage(
                    imageUrl: _attraction!.imageUrls.isNotEmpty 
                        ? _attraction!.imageUrls.first 
                        : 'https://via.placeholder.com/400x300',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                    placeholder: (context, url) => Container(
                      color: AppColors.divider,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.divider,
                      child: const Icon(
                        Icons.place,
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
                  
                  // Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.go('/'),
                      ),
                    ),
                  ),
                  
                  // Favorite Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.favorite,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _attraction!.name,
                          style: AppTextStyles.headline2,
                        ),
                      ),
                      if (_attraction!.averageRating > 0) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: _attraction!.averageRating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: AppColors.rating,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _attraction!.averageRating.toStringAsFixed(1),
                                  style: AppTextStyles.body1,
                                ),
                              ],
                            ),
                            Text(
                              '(${_attraction!.totalReviews} reviews)',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.paddingSmall),
                  
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Text(
                      _getCategoryDisplayName(_attraction!.category),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  // Description
                  Text(
                    'About',
                    style: AppTextStyles.headline4,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    _attraction!.description,
                    style: AppTextStyles.body1,
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Contact Information
                  _buildInfoSection('Contact Information', [
                    if (_attraction!.address.isNotEmpty)
                      _buildInfoRow(Icons.location_on, 'Address', _attraction!.address),
                    if (_attraction!.phoneNumber.isNotEmpty)
                      _buildInfoRow(Icons.phone, 'Phone', _attraction!.phoneNumber),
                    if (_attraction!.website.isNotEmpty)
                      _buildInfoRow(Icons.language, 'Website', _attraction!.website, isLink: true),
                    if (_attraction!.openingHours.isNotEmpty)
                      _buildInfoRow(Icons.access_time, 'Opening Hours', _attraction!.openingHours),
                  ]),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Tags
                  if (_attraction!.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: AppTextStyles.headline4,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Wrap(
                      spacing: AppConstants.paddingSmall,
                      runSpacing: 4,
                      children: _attraction!.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
                  
                  // Reviews Section
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                if (isLink)
                  GestureDetector(
                    onTap: () => _launchUrl(value),
                    child: Text(
                      value,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: AppTextStyles.body2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: AppTextStyles.headline4,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: Navigate to reviews screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        
        if (_reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'No reviews yet',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.take(3).length,
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _buildReviewCard(review);
            },
          ),
      ],
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.userProfileImage != null
                      ? CachedNetworkImageProvider(review.userProfileImage!)
                      : null,
                  child: review.userProfileImage == null
                      ? Text(review.userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: AppColors.rating,
                  ),
                  itemCount: 5,
                  itemSize: 16.0,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              review.comment,
              style: AppTextStyles.body2,
            ),
          ],
        ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}