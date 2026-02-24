import 'dart:io';

import 'package:chat_application_task/core/errors/exceptions.dart';
import 'package:chat_application_task/core/shared/providers.dart';
import 'package:chat_application_task/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteSourceProvider = Provider<IUserRemoteSource>((ref) {
  return UserRemoteSources(ref.watch(firebaseFirestoreProvider));
});

abstract class IUserRemoteSource {
  Stream<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(String userId);
}

class UserRemoteSources implements IUserRemoteSource {
  final FirebaseFirestore _firestore;

  UserRemoteSources(this._firestore);

  @override
  Stream<List<UserModel>> getAllUsers() {
    try {
      return _firestore
          .collection('USERS')
          .snapshots()
          .map(
            (user) =>
                user.docs.map((doc) => UserModel.fromJson(doc.data())).toList(),
          );
    } catch (e) {
      throw UnknownException(message: "Failed to fetch users: ${e.toString()}");
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _firestore
          .collection('USERS')
          .doc(userId)
          .get()
          .then((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null);
    } on SocketException catch (e) {
      throw NetworkException(message: "Network error: ${e.message}");
    } on FirebaseException catch (e) {
      throw FirebaseDataException(message: "Firebase error: ${e.message}");
    } catch (e) {
      throw UnknownException(message: "Failed to fetch user: ${e.toString()}");
    }
  }
}
