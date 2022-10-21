import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/screens/auth_screen.dart';
import 'package:my_app/services/user_service.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  var _showLoading = false;

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final screenSize = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              height: screenSize.height * 0.5,
              width: screenSize.width * 0.75,
              child: _showLoading
                  ? const CircularProgressIndicator(
                      semanticsLabel: 'Creating Account',
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailFieldController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            icon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty.';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Invalid Email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordFieldController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password email',
                            icon: Icon(Icons.lock_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              userService.createNewUser(
                                _emailFieldController.text.toString(),
                                _passwordFieldController.text.toString(),
                              );
                            }
                            setState(() {
                              _showLoading = false;
                            });
                          },
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(height: 18.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              userService
                                  .signInUser(
                                _emailFieldController.text.toString(),
                                _passwordFieldController.text.toString(),
                              )
                                  .then((value) {
                                if (value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AuthScreen(),
                                    ),
                                  );
                                }
                              });
                            }
                            setState(() {
                              _showLoading = false;
                            });
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
