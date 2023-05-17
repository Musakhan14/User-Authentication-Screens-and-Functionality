// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:property_app/screens/auth/signup_page.dart';

import '../../Utils/utils.dart';
import '../../const/const.dart';
import 'auth_widgets/auth_custom_button.dart';
import 'auth_widgets/auth_textfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  bool loading1 = false;
  final _usernameController = TextEditingController();

  void logIn() {
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
          .signInWithEmailAndPassword(email: input, password: password)
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
      _auth.signInWithPhoneNumber(input).then((value) {
        Utils().toastMessage("Phone number authentication successful");
        String username = _usernameController.text;
        Navigator.pushNamed(context, 'BNavigationBar', arguments: username);
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        Utils().toastMessage(error.toString());
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    color: const Color(0xffEBEBEB),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Image(
                                    image: AssetImage(
                                      'assets/images/Logo.png',
                                    ),
                                    height: 40,
                                    width: 40),
                                const SizedBox(width: 10),
                                Text(
                                  'Prpoerty Advisor',
                                  style: authTextStyle.copyWith(fontSize: 22),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              'Please login or signup to continue',
                              style: authTextStyle,
                            ),
                            const SizedBox(height: 20.0),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AuthCustomTextField(
                                    controller: _inputController,
                                    labelText: 'Email or Phone',
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Email or Phone';
                                      }
                                      final bool isEmail = RegExp(
                                              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                                          .hasMatch(value);
                                      final bool isPhoneNumber =
                                          RegExp(r'^\+?[1-9]\d{1,14}$')
                                              .hasMatch(value);
                                      if (!isEmail && !isPhoneNumber) {
                                        return 'Enter a valid Email or Phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  AuthCustomTextField(
                                    controller: _passwordController,
                                    labelText: 'Password',
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Password';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Center(
                              child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: CElevatedButton(
                                    bText: 'Login',
                                    loading: loading,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        logIn();
                                      }
                                    },
                                  )),
                            ),
                            const SizedBox(height: 15.0),
                            Center(
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Forgot Password?',
                                  style: authTextStyle,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have account?'),
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
