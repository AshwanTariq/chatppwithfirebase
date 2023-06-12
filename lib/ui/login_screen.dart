import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_tech_chat_app/ui/signup_screen.dart';
import 'package:fab_tech_chat_app/utils/msgFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _email = '';
  String _password = '';
  bool flag = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      flag = true;
                    });
                    _email = _emailController.text.trim();
                    _password = _passwordController.text.trim();
                    loginWithEmailAndPassword(_email, _password, context);
                  }
                },
                child: flag ? const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ) :const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await fetchUserFromFirestore(user.uid,context);
      } else {
        setState(() {
          flag = false;
        });
        showMsg(context, "User Not found");
      }

      print('Login Successful');
    } catch (error) {
      setState(() {
        flag = false;
      });
      showMsg(context, error.toString());

      print('Login Failed: $error');
    }
  }
}
