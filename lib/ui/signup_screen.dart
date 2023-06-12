import 'package:fab_tech_chat_app/utils/msgFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/UserModel.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _name = '';
  String _email = '';
  String _password = '';
  bool flag = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
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
                      flag=true;
                    });
                    _name = _nameController.text.trim();
                    _email = _emailController.text.trim();
                    _password = _passwordController.text.trim();
                    registerUser(_name, _email, _password);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: flag ? CircularProgressIndicator() : Text('Signup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser(String name, String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        String? fcmToken = await messaging.getToken();
        final UserModel newUser = UserModel(
          name: name,
          id: user.uid,
          fcmToken: fcmToken ?? "",
          addTime: DateTime.now().toString(),
          email: email,
        );

        await saveUserToFirestore(newUser);
      }
      setState(() {
        flag=false;
      });
      showMsg(context, "Signup Successful");
      print('Signup Successful');
    } catch (e) {
      setState(() {
        flag=false;
      });
      showMsg(context, "Signup Failed: $e");
      print('Signup Failed: $e');
    }
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toJson());
      setState(() {
        flag=false;
      });
      showMsg(context, "User saved to Firestore");
      print('User saved to Firestore');
    } catch (e) {
      setState(() {
        flag=false;
      });
      showMsg(context, 'Failed to save user to Firestore: $e');

      print('Failed to save user to Firestore: $e');
    }
  }
}
