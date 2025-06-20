import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Firebase: $e');
      rethrow;
    }
  }

  bool get isInitialized => _isInitialized;
}