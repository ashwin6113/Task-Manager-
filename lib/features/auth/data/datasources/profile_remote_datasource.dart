import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {

  ProfileRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<UserProfileModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfileModel.fromJson(doc.data()!..putIfAbsent('uid', () => uid));
  }

  Future<void> createUserProfile(UserProfileModel profile) async {
    await _usersCollection.doc(profile.uid).set(profile.toJson());
  }

  Future<void> updateUserProfile(UserProfileModel profile) async {
    await _usersCollection.doc(profile.uid).update(profile.toJson());
  }
}
