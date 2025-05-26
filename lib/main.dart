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
import 'package:katomaran_hackathon/services/auth_service.dart';

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
      ],
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: app_theme.AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        darkTheme: app_theme.AppTheme.lightTheme, // You can add a dark theme later
        themeMode: ThemeMode.light,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          AppConstants.homeRoute: (context) => const MainNavScreen(initialIndex: 1), // Home is at index 1
          AppConstants.loginRoute: (context) => const LoginScreen(),
          AppConstants.registerRoute: (context) => const RegisterScreen(),
          // MainNavScreen handles all main app screens (Dashboard, Home, Profile, etc.)
          '/main': (context) => const MainNavScreen(),
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
    // Check if user is logged in after splash delay
    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return;
      if (user != null) {
        // User is logged in - go to main app with bottom nav
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // User is NOT logged in - show login screen
        Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
      }
    });
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
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // Tagline
            const Text(
              'Stay organized, be productive',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
