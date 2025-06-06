// Same imports as before
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:katomaran_hackathon/services/auth_service.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';
import 'package:katomaran_hackathon/utils/constants.dart';
import 'package:katomaran_hackathon/providers/theme_provider.dart';
import 'package:katomaran_hackathon/utils/logger_util.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  User? _user;
  late final AuthService _authService = Provider.of<AuthService>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        _user = FirebaseAuth.instance.currentUser;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.log(Level.error, 'Failed to load user data: $e');
      setState(() => _isLoading = false);
      _showSnackBar('Failed to load user data');
    }
  }

  Future<void> _handleSignOut() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(AppConstants.loginRoute, (route) => false);
    } catch (e) {
      AppLogger.log(Level.error, 'Failed to sign out: $e');
      _showSnackBar('Failed to sign out');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? 'No email provided',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha((0.7 * 255).round()),
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
                  backgroundColor: theme.colorScheme.error,
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
                          color: theme.colorScheme.onError,
                        ),
                      )
                    : Icon(Icons.logout, color: theme.colorScheme.onError),
                label: Text(
                  _isLoading ? 'Signing out...' : 'Sign Out',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onError,
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
      )),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  void _showThemeSelector(ThemeProvider themeProvider) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Choose Theme',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              RadioListTile<ThemePreference>(
                title: const Text('System Default'),
                subtitle: const Text('Use system theme settings'),
                value: ThemePreference.system,
                groupValue: themeProvider.themePreference,
                onChanged: (val) => _handleThemeChange(val, themeProvider),
              ),
              RadioListTile<ThemePreference>(
                title: const Text('Light'),
                subtitle: const Text('Always use light theme'),
                value: ThemePreference.light,
                groupValue: themeProvider.themePreference,
                onChanged: (val) => _handleThemeChange(val, themeProvider),
              ),
              RadioListTile<ThemePreference>(
                title: const Text('Dark'),
                subtitle: const Text('Always use dark theme'),
                value: ThemePreference.dark,
                groupValue: themeProvider.themePreference,
                onChanged: (val) => _handleThemeChange(val, themeProvider),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _handleThemeChange(ThemePreference? preference, ThemeProvider themeProvider) {
    if (preference != null) {
      themeProvider.setThemePreference(preference);
      Navigator.pop(context);
      _showSnackBar('Theme changed to ${preference.toString().split('.').last}');
    }
  }
}
