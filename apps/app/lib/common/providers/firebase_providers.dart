import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FirebaseFirestoreのインスタンスを提供するプロバイダー
/// テスト時にはこのプロバイダーをオーバーライドすることで、
/// FakeFirebaseFirestoreを注入できる
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// FirebaseAuthのインスタンスを提供するプロバイダー
/// テスト時にはこのプロバイダーをオーバーライドすることで、
/// FakeFirebaseAuthを注入できる
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});