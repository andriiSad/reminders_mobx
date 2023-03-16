import 'package:reminders_mobx/provider/auth_provider.dart';

class MockAuthProvider implements AuthProvider {
  @override
  Future<bool> deleteAccountAndSignOut() {
    // TODO: implement deleteAccountAndSignOut
    throw UnimplementedError();
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
  // TODO: implement userId
  String? get userId => throw UnimplementedError();
}
