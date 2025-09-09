import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final bool showReviews;
  final bool isEditable;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final bool showLabel;

  const RatingWidget({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.showReviews = true,
    this.isEditable = false,
    this.onRatingChanged,
    this.size = 20,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: size,
          ignoreGestures: !isEditable,
          itemBuilder: (context, index) {
            return const Icon(
              Icons.star,
              color: AppColors.rating,
            );
          },
          onRatingUpdate: onRatingChanged ?? (rating) {},
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.rating,
          ),
          if (showReviews && totalReviews > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($totalReviews)',
              style: AppTextStyles.body3,
            ),
          ],
        ],
      ],
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBadge({
    super.key,
    required this.rating,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AppDecorations.ratingBadgeDecoration,
      child: Center(
        child: Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.body3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final String title;
  final VoidCallback? onTap;

  const RatingCard({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.cardDecoration,
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.headline4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RatingWidget(
              rating: rating,
              totalReviews: totalReviews,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              _getRatingText(rating),
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 3.0) return 'Average';
    if (rating >= 2.0) return 'Below Average';
    return 'Poor';
  }
}

class RatingInputDialog extends StatefulWidget {
  final double initialRating;
  final String title;
  final String? comment;

  const RatingInputDialog({
    super.key,
    this.initialRating = 0,
    required this.title,
    this.comment,
  });

  @override
  State<RatingInputDialog> createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  late double _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _commentController = TextEditingController(text: widget.comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          RatingWidget(
            rating: _rating,
            isEditable: true,
            size: 32,
            showLabel: false,
            onRatingChanged: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Add a comment (optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'rating': _rating,
              'comment': _commentController.text.trim(),
            });
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
