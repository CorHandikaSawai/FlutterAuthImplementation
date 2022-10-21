import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/main.dart';
import 'package:my_app/screens/sign_in_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Widget root = const SignInScreen();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user != null){
        setState(() {
          root = const MyHomePage(title: '',);
        });
      }
    });
    return root;
  }
}