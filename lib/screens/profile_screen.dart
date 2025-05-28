// Same imports as before
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:katomaran_hackathon/services/auth_service.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';
import 'package:katomaran_hackathon/utils/constants.dart';
import 'package:katomaran_hackathon/providers/theme_provider.dart';

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
      await FirebaseAuth.instance.currentUser?.reload();
      if (mounted) {
        setState(() {
          _user = FirebaseAuth.instance.currentUser;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
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
        Navigator.of(context).pushNamedAndRemoveUntil(AppConstants.loginRoute, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to sign out'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _user ?? FirebaseAuth.instance.currentUser;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
            color: theme.colorScheme.primary,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 54,
                backgroundColor: AppTheme.primaryLightColor,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('images/default_avatar.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            // Display Name
            Text(
              user?.displayName ?? 'Guest User',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                inherit: false,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? 'No email provided',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha((0.7 * 255).round()),
                inherit: false,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            // Info card
            Card(
              margin: const EdgeInsets.only(bottom: 28),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user?.email ?? 'Not provided',
                    ),
                    const Divider(height: 20),
                    _buildListTile(
                      icon: Icons.phone,
                      title: 'Phone',
                      subtitle: user?.phoneNumber ?? 'Not provided',
                    ),
                    const Divider(height: 20),
                    _buildListTile(
                      icon: Icons.verified_user,
                      title: 'Email Verified',
                      subtitle: user?.emailVerified == true ? 'Verified' : 'Not Verified',
                    ),
                    const Divider(height: 20),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            themeProvider.themePreference == ThemePreference.dark
                                ? Icons.dark_mode
                                : themeProvider.themePreference == ThemePreference.light
                                    ? Icons.light_mode
                                    : Icons.phone_android,
                            color: theme.colorScheme.primary,
                          ),
                          title: Text('Theme', style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                          subtitle: Text(
                            themeProvider.themePreference == ThemePreference.dark
                                ? 'Dark'
                                : themeProvider.themePreference == ThemePreference.light
                                    ? 'Light'
                                    : 'System',
                          ),
                          onTap: () => _showThemeSelector(themeProvider),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Sign out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSignOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      )
                    : Icon(Icons.logout, color: Theme.of(context).colorScheme.onError),
                label: Text(
                  _isLoading ? 'Signing out...' : 'Sign Out',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                    inherit: false,
                    fontWeight: FontWeight.w600,
                  ),
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
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 24,
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        inherit: false,
      )),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        inherit: false,
      )),
    );
  }

  void _showThemeSelector(ThemeProvider themeProvider) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemePreference>(
              title: Text('System Default', style: theme.textTheme.bodyLarge),
              value: ThemePreference.system,
              groupValue: themeProvider.themePreference,
              onChanged: (ThemePreference? val) {
                if (val != null) themeProvider.setThemePreference(val);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemePreference>(
              title: Text('Light Theme', style: theme.textTheme.bodyLarge),
              value: ThemePreference.light,
              groupValue: themeProvider.themePreference,
              onChanged: (ThemePreference? val) {
                if (val != null) themeProvider.setThemePreference(val);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemePreference>(
              title: Text('Dark Theme', style: theme.textTheme.bodyLarge),
              value: ThemePreference.dark,
              groupValue: themeProvider.themePreference,
              onChanged: (ThemePreference? val) {
                if (val != null) themeProvider.setThemePreference(val);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
