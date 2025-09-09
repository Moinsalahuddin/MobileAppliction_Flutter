import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  UserModel? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final userData = await authService.getUserData(user.uid);
      if (mounted) {
        setState(() {
          _currentUser = userData;
        });
      }
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accent color from your system
    final accentColor = const Color(0xFFFF7A00); // Orange

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F6), // pale grey
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF111111),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111111)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF111111)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile feature coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: accentColor,
                            backgroundImage: _currentUser!.profileImageUrl != null
                                ? NetworkImage(_currentUser!.profileImageUrl!)
                                : null,
                            child: _currentUser!.profileImageUrl == null
                                ? Text(
                                    _currentUser!.firstName[0].toUpperCase() +
                                        _currentUser!.lastName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentUser!.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF111111),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentUser!.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF9E9E9E),
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Member since ${_currentUser!.createdAt.year}',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menu Sections
                  _buildMenuSection('Account', [
                    _buildMenuItem(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                    _buildMenuItem(
                      icon: Icons.security,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _buildMenuSection('Preferences', [
                    _buildMenuItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notification settings',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                    _buildMenuItem(
                      icon: Icons.attach_money,
                      title: 'Currency',
                      subtitle: 'Set your preferred currency',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _buildMenuSection('Data', [
                    _buildMenuItem(
                      icon: Icons.download,
                      title: 'Export Data',
                      subtitle: 'Download your trip and expense data',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                    _buildMenuItem(
                      icon: Icons.backup,
                      title: 'Backup & Sync',
                      subtitle: 'Manage your data backup settings',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _buildMenuSection('Support', [
                    _buildMenuItem(
                      icon: Icons.help,
                      title: 'Help & FAQ',
                      subtitle: 'Get help and find answers',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                    _buildMenuItem(
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts with us',
                      onTap: () {},
                      accentColor: accentColor,
                    ),
                    _buildMenuItem(
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'TripBudget',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(
                            Icons.account_balance_wallet,
                            size: 48,
                            color: accentColor,
                          ),
                          children: const [
                            Text('Track your travel expenses with ease.'),
                          ],
                        );
                      },
                      accentColor: accentColor,
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _showSignOutDialog,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.logout),
                      label: Text(_isLoading ? 'Signing Out...' : 'Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9E9E9E), // inactive grey
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: accentColor.withOpacity(0.1),
        child: Icon(icon, color: accentColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF9E9E9E))),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9E9E9E)),
      onTap: onTap,
    );
  }
}
