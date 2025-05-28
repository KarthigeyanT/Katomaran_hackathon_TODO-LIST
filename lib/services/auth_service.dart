import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:logger/logger.dart';

import '../utils/logger_util.dart';

class AuthService with ChangeNotifier {
  // Track if the service is disposed
  bool _disposed = false;
  final FirebaseAuth _auth;
  final FacebookAuth _facebookAuth;

  AuthService({FirebaseAuth? auth, FacebookAuth? facebookAuth}) 
    : _auth = auth ?? FirebaseAuth.instance,
      _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Helper to check if we should proceed with operations
  bool get _isReady => !_disposed;
  
  // Expose the current user
  User? get currentUser => _auth.currentUser;

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    if (!_isReady) return null;
    
    try {
      if (kDebugMode) {
        AppLogger.log(Level.info, 'Starting Facebook login...');
        if (kIsWeb) {
          AppLogger.log(Level.info, 'Running on web platform');
        }
      }

      // Request login permissions with email and public profile
      AppLogger.log(Level.info, 'Requesting Facebook login...');
      final loginResult = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      AppLogger.log(Level.info, 'Facebook login result: \\${loginResult.status}');

      if (loginResult.status == LoginStatus.success) {
        final accessToken = loginResult.accessToken;
        AppLogger.log(Level.info, 'Facebook access token received');

        // Get the user data from Facebook
        final userData = await _facebookAuth.getUserData();
        AppLogger.log(Level.info, 'Facebook user data received');

        // Create a credential from the access token
        final credential = FacebookAuthProvider.credential(
          accessToken!.tokenString,
        );

        // Sign in to Firebase with the Facebook credential
        final userCredential = await _auth.signInWithCredential(credential);
        
        // Update the user's profile with Facebook data
        final user = userCredential.user;
        if (user != null) {
          final updateFutures = <Future>[];
          
          if (userData['name'] != null) {
            updateFutures.add(user.updateDisplayName(userData['name']));
          }
          if (userData['picture']?['data']?['url'] != null) {
            updateFutures.add(
              user.updatePhotoURL(userData['picture']['data']['url']),
            );
          }
          
          if (updateFutures.isNotEmpty) {
            await Future.wait(updateFutures);
          }
        }

        if (_isReady) {
          notifyListeners();
        }
        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        AppLogger.log(Level.info, 'Facebook login was cancelled by user');
        return null;
      } else {
        final errorMessage = loginResult.message ?? 'Unknown error occurred during Facebook login';
        AppLogger.log(Level.error, 'Facebook login failed: \\${errorMessage}');
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: errorMessage,
        );
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.log(Level.error, 'Firebase auth error in signInWithFacebook: \\${e.code} - \\${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.log(Level.error, 'Error in signInWithFacebook: \\${e}');
      AppLogger.log(Level.error, 'Stack trace: \\${stackTrace}');
      throw FirebaseAuthException(
        code: 'ERROR_UNKNOWN',
        message: 'An unknown error occurred during Facebook sign in',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _facebookAuth.logOut(),
      ]);
      if (_isReady) {
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.log(Level.error, 'Firebase auth error during sign out: \\${e}');
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.log(Level.error, 'Unexpected error during sign out: \\${e}\\n\\${stackTrace}');
      rethrow;
    }
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
