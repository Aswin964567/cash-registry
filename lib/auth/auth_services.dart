import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user!.updateDisplayName(displayName);
      return cred.user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<User?> signinUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // await cred.user!.updateDisplayName("hello");
      return cred.user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}
