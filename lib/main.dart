import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katomaran_hackathon/screens/main_nav_screen.dart';
import 'package:katomaran_hackathon/screens/login_screen_new.dart';
import 'package:katomaran_hackathon/screens/register_screen.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart' as app_theme;
import 'package:katomaran_hackathon/utils/constants.dart';
import 'package:katomaran_hackathon/providers/task_provider.dart';
import 'package:katomaran_hackathon/providers/theme_provider.dart';
import 'package:katomaran_hackathon/services/auth_service.dart';

// Theme provider is used via Consumer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Web-specific initialization
  if (kIsWeb) {
    // Set Firebase persistence
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    
    // Initialize Facebook SDK for web
    // This resolves the 'window.FB is undefined' error
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: '1880898542697941', 
      cookie: true,
      xfbml: true,
      version: 'v17.0',
    );
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          // Initialize theme before first frame
          lazy: false,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // Get the current theme data based on the theme mode
          final isDark = themeProvider.themeMode == ThemeMode.dark;
          final themeData = isDark ? app_theme.AppTheme.darkTheme : app_theme.AppTheme.lightTheme;
          
          // Apply custom text theme with Google Fonts
          final textTheme = GoogleFonts.interTextTheme(themeData.textTheme);
          
          return MaterialApp(
            title: 'Katomaran',
            debugShowCheckedModeBanner: false,
            theme: themeData.copyWith(
              textTheme: textTheme,
              // Ensure consistent theming for all widgets
              appBarTheme: themeData.appBarTheme.copyWith(
                backgroundColor: isDark ? app_theme.AppTheme.darkAppBarColor : app_theme.AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              // Add more theme overrides as needed
            ),
            darkTheme: themeData,
            themeMode: themeProvider.themeMode,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              AppConstants.homeRoute: (context) => MainNavScreen(initialIndex: 0), // Dashboard is at index 0
              AppConstants.loginRoute: (context) => const LoginScreen(),
              AppConstants.registerRoute: (context) => const RegisterScreen(),
              // MainNavScreen handles all main app screens (Dashboard, Home, Profile, etc.)
              '/main': (context) => MainNavScreen(initialIndex: 0), // Default to Dashboard
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Log app initialization start
      AppLogger.i('Initializing app...');
      
      // Add a small delay for the splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Check authentication status
      final user = FirebaseAuth.instance.currentUser;
      
      // Log user status and handle navigation
      if (user != null) {
        AppLogger.i('User is already logged in: ${user.uid}');
        // Set user identifier for crash reporting
        await CrashReporting.setUserIdentifier(user.uid);
        // Navigate to main app
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        AppLogger.i('No user logged in, showing login screen');
        // Navigate to login screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
        }
      }
    } catch (error, stackTrace) {
      // Log any errors during initialization
      AppLogger.e(error, stackTrace);
      
      // Even if there's an error, try to navigate to login screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26), // 0.1 opacity equivalent
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 60,
                color: app_theme.AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Changed from white to black87 for better visibility
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // Tagline
            Text(
              'Stay organized, be productive',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Changed from white70 to black54 for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
