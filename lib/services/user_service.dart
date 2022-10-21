import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> erroMessage = [];
  bool _isUserSignedIn = false;
  User? get currentUser {
    if (_auth.currentUser!.emailVerified) {
      return _auth.currentUser;
    }
    return null;
  }

  Future<void> createNewUser(String email, String password) async {
    String res;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await value.user!.sendEmailVerification();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        res = 'Email already in use';
      } else {
        res = e.code.toString();
      }
      erroMessage.add(res);
    }
  }

  //TODO: Error is user has not verified email.

  Future<bool> signInUser(String email, String password) async {
    String res;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          if (!(value.user!.emailVerified)) {
            await value.user!.sendEmailVerification().then((value) {
              res = 'Please verify your email!';
              _isUserSignedIn = false;
            });
          } else if (value.user!.emailVerified) {
            _isUserSignedIn = true;
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' ||
          e.code == 'user-disabled' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        res = 'Invalid email or password';
      } else {
        res = e.code.toString();
      }
      erroMessage.add(res);
    }
    return _isUserSignedIn;
  }

  signOutUser() async {
    await _auth.signOut();
  }
}
