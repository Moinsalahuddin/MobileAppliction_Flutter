import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isAuthenticated) {
        final user = await authService.getUserById(authService.currentUser!.uid);
        setState(() {
          _user = user;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logoutUser();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: Text('User not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/edit-profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Profile Options
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: _user!.profileImageUrl != null
                  ? CachedNetworkImageProvider(_user!.profileImageUrl!)
                  : null,
              child: _user!.profileImageUrl == null
                  ? Text(
                      _user!.name[0].toUpperCase(),
                      style: AppTextStyles.headline1.copyWith(
                        fontSize: 32,
                        color: AppColors.surface,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // User Name
            Text(
              _user!.name,
              style: AppTextStyles.headline3,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.paddingSmall),
            
            // Email
            Text(
              _user!.email,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (_user!.phoneNumber != null) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                _user!.phoneNumber!,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Member Since
            Text(
              'Member since ${_formatDate(_user!.createdAt)}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        // Account Settings
        _buildSection(
          'Account',
          [
            _buildOptionTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => context.go('/edit-profile'),
            ),
            _buildOptionTile(
              icon: Icons.favorite,
              title: 'My Favorites',
              subtitle: '${_user!.favoriteAttractions.length} saved attractions',
              onTap: () {
                // TODO: Navigate to favorites screen
              },
            ),
            _buildOptionTile(
              icon: Icons.reviews,
              title: 'My Reviews',
              subtitle: 'View your submitted reviews',
              onTap: () {
                // TODO: Navigate to reviews screen
              },
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.paddingMedium),
        
        // App Settings
        _buildSection(
          'Settings',
          [
            _buildOptionTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {
                // TODO: Navigate to notifications settings
              },
            ),
            _buildOptionTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // TODO: Show privacy policy
              },
            ),
            _buildOptionTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                // TODO: Navigate to help screen
              },
            ),
            _buildOptionTile(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version ${AppConstants.appVersion}',
              onTap: () {
                // TODO: Show about dialog
              },
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.paddingMedium),
        
        // Admin Section (if user is admin)
        if (_user!.isAdmin) ...[
          _buildSection(
            'Admin',
            [
              _buildOptionTile(
                icon: Icons.admin_panel_settings,
                title: 'Admin Dashboard',
                subtitle: 'Manage attractions and content',
                onTap: () => context.go('/admin'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
        ],
        
        // Logout
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showLogoutDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline4,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }
}
