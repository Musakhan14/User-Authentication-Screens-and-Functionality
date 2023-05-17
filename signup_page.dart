// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_app/Screens/auth/verification_page.dart';
import 'package:property_app/Utils/utils.dart';
import 'package:property_app/screens/auth/auth_widgets/fab_google_login_button.dart';
import 'auth_widgets/auth_custom_button.dart';
import 'auth_widgets/auth_textfeild.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  void signUp() {
    setState(() {
      loading = true;
    });
    final String input = _inputController.text;
    final String password = _passwordController.text;
    final bool isEmail = RegExp(
            r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
        .hasMatch(input);

    if (isEmail) {
      _auth
          .createUserWithEmailAndPassword(email: input, password: password)
          .then((value) {
        Utils().toastMessage(value.user!.email.toString());
        String username = _usernameController.text;
        Navigator.pushNamed(context, 'BNavigationBar', arguments: username);
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    } else {
      _auth
          .verifyPhoneNumber(
              phoneNumber: input,
              verificationCompleted: (_) {},
              verificationFailed: (e) {
                Utils().toastMessage(e.toString());
              },
              codeSent: (String verificationId, int? token) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationPage(
                      username: _usernameController.text,
                      verificationId: verificationId,
                    ),
                  ),
                );
              },
              codeAutoRetrievalTimeout: (String verificationId) {})
          .onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Form(
            key: _formKey,
            // ignore: sized_box_for_whitespace
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
              ),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                color: const Color(0xffEBEBEB),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AuthCustomTextField(
                          controller: _usernameController,
                          labelText: 'Enter your Name',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthCustomTextField(
                          controller: _inputController,
                          labelText: 'Enter Email or Phone',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email or phone number';
                            }

                            final bool isEmail = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                                .hasMatch(value);

                            final bool isPhoneNumber =
                                RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value);

                            if (!isEmail && !isPhoneNumber) {
                              return 'Please enter a valid email or phone number';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthCustomTextField(
                          controller: _passwordController,
                          labelText: 'Enter password',
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            height: 50,
                            child: CElevatedButton(
                              bText: 'Sign Up',
                              loading: loading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              },
                            )),
                        const SizedBox(height: 15),
                        FabGoogleLoginButton(
                          onPressed: () {},
                          icon: Icons.facebook,
                          buttonText: 'Login with Facebook',
                        ),
                        const SizedBox(height: 15),
                        FabGoogleLoginButton(
                          onPressed: () {},
                          icon: FontAwesomeIcons.google,
                          buttonText: 'Login with Google',
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have Account ?'),
                            const SizedBox(width: 4.0),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Text(
                                'LogIn',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
