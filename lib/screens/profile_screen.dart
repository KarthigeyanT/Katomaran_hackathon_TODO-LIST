import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:katomaran_hackathon/services/auth_service.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';
import 'package:katomaran_hackathon/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  User? _user;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (mounted) setState(() => _isLoading = true);
    
    try {
      // Force refresh the user data
      await FirebaseAuth.instance.currentUser?.reload();
      if (mounted) {
        setState(() {
          _user = FirebaseAuth.instance.currentUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      setState(() => _isLoading = true);
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign out')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user ?? FirebaseAuth.instance.currentUser;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryLightColor,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 24),
            // User Name
            Text(
              user?.displayName ?? 'Guest User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // User Email
            Text(
              user?.email ?? 'No email provided',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            // Account Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user?.email ?? 'Not provided',
                    ),
                    const Divider(),
                    _buildListTile(
                      icon: Icons.phone,
                      title: 'Phone',
                      subtitle: user?.phoneNumber ?? 'Not provided',
                    ),
                    const Divider(),
                    _buildListTile(
                      icon: Icons.verified_user,
                      title: 'Email Verified',
                      subtitle: user?.emailVerified == true ? 'Verified' : 'Not Verified',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // User Since
            if (user?.metadata.creationTime != null)
              Text(
                'Member since ${user!.metadata.creationTime!.year}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 24),
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSignOut,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.errorColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  _isLoading ? 'Signing Out...' : 'Sign Out',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle.isNotEmpty ? subtitle : 'Not provided',
        style: TextStyle(
          color: subtitle.isNotEmpty 
              ? AppTheme.textPrimary 
              : AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 8,
      onTap: onTap,
      trailing: onTap != null 
          ? const Icon(Icons.edit, size: 18, color: AppTheme.primaryColor)
          : null,
    );
  }
}
