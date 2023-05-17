import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:property_app/screens/auth/auth_widgets/auth_textfeild.dart';

import '../../Utils/utils.dart';
import 'auth_widgets/auth_custom_button.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  final String username;
  const VerificationPage(
      {Key? key, required this.verificationId, required this.username})
      : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _codeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  // final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // ignore: prefer_const_constructors
        title: Text('Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              elevation: 3,
              color: const Color(0xffEBEBEB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Enter verification code',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthCustomTextField(
                      controller: _codeController,
                      labelText: 'Verification Cod',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a verification code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CElevatedButton(
                      bText: 'Verify Code',
                      loading: loading,
                      onPressed: () async {
                        final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: _codeController.text.toString());

                        try {
                          await _auth.signInWithCredential(credential);
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(
                            context,
                            'BNavigationBar',
                            arguments: widget.username,
                          );
                        } catch (e) {
                          Utils().toastMessage(e.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
