import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createNewUser(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await value.user!.sendEmailVerification();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'Email already in use';
      } else {
        return e.code.toString();
      }
    }
    return 'Successful. Please verify your email!';
  }

  Future<String> signInUser(String email, String password) async {
    late String _res;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          if (!(value.user!.emailVerified)) {
            await value.user!.sendEmailVerification();
            _res = 'Please verify your email!'; //TODO: Maybe I can use something else
          }
          else if(value.user!.emailVerified){
            _res = 'login';
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' ||
          e.code == 'user-disabled' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        _res = 'Invalid email or password';
      } else {
        _res = e.code.toString();
      }
    }
    return _res;
  }
}
