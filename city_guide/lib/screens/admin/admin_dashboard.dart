import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Manage your city guide content',
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingMedium,
                mainAxisSpacing: AppConstants.paddingMedium,
                children: [
                  _buildAdminCard(
                    context,
                    icon: Icons.place,
                    title: 'Attractions',
                    subtitle: 'Manage attractions',
                    color: AppColors.primary,
                    onTap: () => context.go('/admin/attractions'),
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.location_city,
                    title: 'Cities',
                    subtitle: 'Manage cities',
                    color: AppColors.secondary,
                    onTap: () {
                      // TODO: Navigate to cities management
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.people,
                    title: 'Users',
                    subtitle: 'Manage users',
                    color: AppColors.accent,
                    onTap: () {
                      // TODO: Navigate to users management
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.reviews,
                    title: 'Reviews',
                    subtitle: 'Manage reviews',
                    color: AppColors.warning,
                    onTap: () {
                      // TODO: Navigate to reviews management
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'View statistics',
                    color: AppColors.info,
                    onTap: () {
                      // TODO: Navigate to analytics
                    },
                  ),
                  _buildAdminCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App settings',
                    color: AppColors.textSecondary,
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                title,
                style: AppTextStyles.headline4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                subtitle,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
