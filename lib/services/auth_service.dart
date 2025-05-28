import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  
  // Facebook App ID - should match the one in strings.xml
  static const String facebookAppId = '1880898542697941';
  
  // Facebook Login instance
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (kDebugMode) {
        AppLogger.i('Starting Facebook login...');
        if (kIsWeb) {
          AppLogger.i('Running on web platform');
        }
      }

      // Request login permissions with email and public profile
      AppLogger.i('Requesting Facebook login...');
      final LoginResult result = await facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );
      AppLogger.i('Facebook login result: ${result.status}');

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        AppLogger.i('Facebook access token: ${accessToken?.tokenString}');

        // Get the user data from Facebook
        final userData = await facebookAuth.getUserData();
        AppLogger.i('Facebook user data: $userData');

        // Create a credential from the access token
        final OAuthCredential credential = 
            FacebookAuthProvider.credential(accessToken!.tokenString);

        // Sign in to Firebase with the Facebook credential
        final UserCredential userCredential = 
            await _auth.signInWithCredential(credential);
        
        // Update the user's profile with Facebook data
        if (userCredential.user != null) {
          await userCredential.user?.updateDisplayName(
            userData['name'] ?? '',
          );
          
          // Update photo URL if available
          if (userData['picture'] != null && 
              userData['picture']['data'] != null &&
              userData['picture']['data']['url'] != null) {
            await userCredential.user?.updatePhotoURL(
              userData['picture']['data']['url'],
            );
          }
          
          // Force token refresh to ensure the latest data
          await userCredential.user?.reload();
          AppLogger.i('Updated user profile with Facebook data');
        }
        
        AppLogger.i('Firebase sign in successful: ${userCredential.user?.uid}');
        return userCredential;
      } else if (result.status == LoginStatus.cancelled) {
        AppLogger.i('Facebook login was cancelled');
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in was cancelled by user',
        );
      } else {
        AppLogger.e('Facebook login failed: ${result.message}');
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: result.message,
        );
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.e('Firebase auth error in signInWithFacebook: ${e.code} - ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e('Error in signInWithFacebook: $e');
      AppLogger.e('Stack trace: $stackTrace');
      throw FirebaseAuthException(
        code: 'ERROR_UNKNOWN',
        message: 'An unknown error occurred during Facebook sign in',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _facebookAuth.logOut();
    notifyListeners();
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
