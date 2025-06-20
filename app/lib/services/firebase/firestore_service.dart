import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> doc(String path) {
    return _firestore.doc(path);
  }

  WriteBatch batch() {
    return _firestore.batch();
  }

  Future<T> runTransaction<T>(TransactionHandler<T> transactionHandler) {
    return _firestore.runTransaction(transactionHandler);
  }
}