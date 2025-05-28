import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen_new.dart';
import 'screens/main_nav_screen.dart';
import 'screens/register_screen.dart';
import 'providers/task_provider.dart';
import 'theme/app_theme.dart' as app_theme;
import 'utils/app_logger.dart';
import 'utils/constants.dart';

Future<void> main() async {
  // Set up error handling
  FlutterError.onError = (details) {
    // Don't await here to avoid blocking the error handling
    final error = details.exception;
    final stack = details.stack;
    // Fire and forget the error log
    AppLogger().e('Flutter error: $error', error, stack);
  };

  // Run in a zone for error handling
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Initialize logger
      final logger = AppLogger();
      // Fire and forget the initial log
      logger.i('App starting...');
      
      try {
        // Initialize Firebase
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        // Fire and forget the success log
        logger.i('Firebase initialized successfully');
      } catch (e, stackTrace) {
        // Fire and forget the error log
        logger.e('Failed to initialize Firebase', e, stackTrace);
        rethrow;
      }
      
      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      // Initialize shared preferences for theme
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode') ?? false;

      // Run the app
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ThemeProvider()..setTheme(isDarkMode),
            ),
            Provider<FirebaseAuth>(
              create: (_) => FirebaseAuth.instance,
            ),
            ChangeNotifierProvider<TaskProvider>(
              create: (_) => TaskProvider(),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      // Log uncaught errors without awaiting
      AppLogger().e('Uncaught error in runZonedGuarded', error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final themeData = isDark ? app_theme.AppTheme.darkTheme : app_theme.AppTheme.lightTheme;
    final textTheme = GoogleFonts.interTextTheme(themeData.textTheme);

    return MaterialApp(
      title: 'Katomaran',
      debugShowCheckedModeBanner: false,
      theme: themeData.copyWith(
        textTheme: textTheme,
        appBarTheme: themeData.appBarTheme.copyWith(
          backgroundColor: isDark ? app_theme.AppTheme.darkAppBarColor : app_theme.AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: themeData,
      themeMode: themeProvider.themeMode,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        AppConstants.homeRoute: (context) => MainNavScreen(initialIndex: 0),
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.registerRoute: (context) => const RegisterScreen(),
        '/main': (context) => MainNavScreen(initialIndex: 0),
      },
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
      // Add a small delay for the splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Check authentication status
      final user = FirebaseAuth.instance.currentUser;
      
      // Log user status and handle navigation
      if (user != null) {
        // Log user login
        AppLogger().i('User logged in: ${user.uid}');
        
        // Navigate to main app
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        AppLogger().i('No user logged in, showing login screen');
        // Navigate to login screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
        }
      }
    } catch (e, stackTrace) {
      // Log any errors during initialization
      AppLogger().e('Error during app initialization', e, stackTrace);
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
