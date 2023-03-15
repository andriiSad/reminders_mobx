import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth_error.dart';

abstract class AuthProvider {
  String? get userId;
  Future<bool> deleteAccountAndSignOut();
  Future<void> signOut();
  Future<bool> register({
    required String email,
    required String password,
  });
  Future<bool> login({
    required String email,
    required String password,
  });
}

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<bool> deleteAccountAndSignOut() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      //delete the user
      await user.delete();
      //log the user out
      await auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      final authError = AuthError.from(e);
      throw authError;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool> register({required String email, required String password}) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
}
