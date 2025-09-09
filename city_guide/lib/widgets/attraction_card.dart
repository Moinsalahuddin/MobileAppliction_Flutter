import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/attraction_model.dart';
import '../utils/constants.dart';

class AttractionCard extends StatelessWidget {
  final AttractionModel attraction;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const AttractionCard({
    super.key,
    required this.attraction,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attraction Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusMedium),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: attraction.imageUrls.isNotEmpty 
                          ? attraction.imageUrls.first 
                          : 'https://via.placeholder.com/400x225',
                      fit: BoxFit.cover,
                      width: double.infinity,
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
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    
                    // Category Badge
                    Positioned(
                      top: AppConstants.paddingSmall,
                      left: AppConstants.paddingSmall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: Text(
                          _getCategoryDisplayName(attraction.category),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    // Favorite Button
                    if (onFavorite != null)
                      Positioned(
                        top: AppConstants.paddingSmall,
                        right: AppConstants.paddingSmall,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border,
                              color: AppColors.favorite,
                            ),
                            onPressed: onFavorite,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Attraction Info
            Padding(
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
                          attraction.name,
                          style: AppTextStyles.headline4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (attraction.averageRating > 0) ...[
                        const SizedBox(width: AppConstants.paddingSmall),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: attraction.averageRating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: AppColors.rating,
                                  ),
                                  itemCount: 5,
                                  itemSize: 16.0,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  attraction.averageRating.toStringAsFixed(1),
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                            Text(
                              '(${attraction.totalReviews} reviews)',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.paddingSmall),
                  
                  // Description
                  Text(
                    attraction.description,
                    style: AppTextStyles.body2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppConstants.paddingSmall),
                  
                  // Location and Price
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          attraction.address.isNotEmpty 
                              ? attraction.address 
                              : 'Location not specified',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (attraction.priceRange > 0) ...[
                        const SizedBox(width: AppConstants.paddingSmall),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _getPriceRangeText(attraction.priceRange),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  
                  // Tags
                  if (attraction.tags.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.paddingSmall),
                    Wrap(
                      spacing: AppConstants.paddingSmall,
                      runSpacing: 4,
                      children: attraction.tags.take(3).map((tag) {
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
                  ],
                ],
              ),
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

  String _getPriceRangeText(double priceRange) {
    if (priceRange <= 1) return 'Budget';
    if (priceRange <= 2) return 'Affordable';
    if (priceRange <= 3) return 'Moderate';
    if (priceRange <= 4) return 'Expensive';
    return 'Luxury';
  }
}