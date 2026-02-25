import 'dart:io';
import 'package:chat_application_task/core/errors/exceptions.dart';
import 'package:chat_application_task/core/errors/firebase_exceptions_mapper.dart';
import 'package:chat_application_task/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../core/shared/providers.dart';
import '../../domain/entities/user_entity.dart';

final authRemoteSourceProvider = Provider<IAuthRemoteSource>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firebaseFirestore = ref.read(firebaseFirestoreProvider);
  return AuthRemoteSource(firebaseAuth, firebaseFirestore);
});

abstract interface class IAuthRemoteSource {
  Future<UserModel> signIn(Map<String, dynamic> signInData);
  Future<UserModel> signUp(Map<String, dynamic> signUpData);
  Future<void> signOut();
  Stream<UserEntity?> authStateChanges();
}

class AuthRemoteSource implements IAuthRemoteSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteSource(this.firebaseAuth, this.firebaseFirestore);

  @override
  Future<UserModel> signIn(Map<String, dynamic> signInData) async {
    try {
      final email = signInData['email'] as String;
      final password = signInData['password'] as String;

      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw AuthenticationException(message: 'User not found');
      } else {
        final userDoc = await firebaseFirestore
            .collection('USERS')
            .doc(result.user!.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          return UserModel.fromJson(userData);
        } else {
          throw AuthenticationException(message: 'User data not found');
        }
      }
    } on FirebaseAuthException catch (e) {
      Logger().e(
        'FirebaseAuthException during sign up: ${e.message} && code: ${e.code}',
      );
      throw FirebaseExceptionsMapper.mapFirebaseException(e);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp(Map<String, dynamic> signUpData) async {
    try {
      final name = signUpData['name'] as String;
      final email = signUpData['email'] as String;
      final password = signUpData['password'] as String;

      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw AuthenticationException(message: 'Registration failed');
      } else {
        final user = result.user!;
        final userModel = UserModel(
          name: name,
          email: email,
          uid: user.uid,
          refreshToken: user.refreshToken ?? '',
          profilePictureUrl: user.photoURL,
        );
        await user.updateDisplayName(name);
        // create in users collection with name and email and uid as id
        await firebaseFirestore
            .collection('USERS')
            .doc(userModel.uid)
            .set(userModel.toJson());
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      Logger().e('FirebaseAuthException during sign up: ${e.message}');
      throw FirebaseExceptionsMapper.mapFirebaseException(e);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserEntity(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        profilePictureUrl: user.photoURL,
      );
    });
  }
}
