import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../services/services.dart';

part 'firebase_providers.g.dart';

// ********************************************************
// * 注意: Auth関連のプロバイダーはservices/firebase/auth_service.dartに移動しました
// ********************************************************

// ********************************************************
// * Firestore
// ********************************************************
@Riverpod(keepAlive: true)
FirestoreService firebaseFirestore(Ref ref) => ref.read(firestoreServiceProvider);

// Raw Firebase Firestore instance for backward compatibility
@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestoreInstance(Ref ref) => FirebaseFirestore.instance;

// ********************************************************
// * Crashlytics
// ********************************************************
@Riverpod(keepAlive: true)
CrashlyticsService firebaseCrashlytics(Ref ref) => ref.read(crashlyticsServiceProvider);

// Raw Firebase Crashlytics instance for backward compatibility
@Riverpod(keepAlive: true)
FirebaseCrashlytics firebaseCrashlyticsInstance(Ref ref) => FirebaseCrashlytics.instance;

// ********************************************************
// * Analytics
// ********************************************************
@riverpod
AnalyticsService firebaseAnalytics(Ref ref) => ref.read(analyticsServiceProvider);

// Raw Firebase Analytics instance for backward compatibility
@riverpod
FirebaseAnalytics firebaseAnalyticsInstance(Ref ref) => FirebaseAnalytics.instance;

// ********************************************************
// * Functions
// ********************************************************
// @Riverpod(keepAlive: true)
// FirebaseFunctions firebaseFunctions(Ref ref) => FirebaseFunctions.instanceFor(
//       region: 'asia-northeast1',
//     );

// ********************************************************
// * Storage
// ********************************************************
// @Riverpod(keepAlive: true)
// FirebaseStorage firebaseStorage(Ref ref) => FirebaseStorage.instance;

// @riverpod
// Future<String> firebaseStorageGsFileDownloadUrl(
//   Ref ref, {
//   required String fileUri,
// }) async {
//   ref.cacheFor(const Duration(minutes: 5));

//   if (fileUri.startsWith('gs://')) {
//     return ref
//         .watch(firebaseStorageProvider)
//         .refFromURL(fileUri)
//         .getDownloadURL();
//   } else {
//     return fileUri;
//   }
// }
