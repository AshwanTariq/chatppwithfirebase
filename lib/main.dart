import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_tech_chat_app/models/UserModel.dart';
import 'package:fab_tech_chat_app/services/notification_service.dart';
import 'package:fab_tech_chat_app/ui/home_screen.dart';
import 'package:fab_tech_chat_app/ui/login_screen.dart';
import 'package:fab_tech_chat_app/utils/msgFile.dart';
import 'package:fab_tech_chat_app/utils/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final FirebaseFirestore firestore;
late final FirebaseMessaging messaging;

Future<UserModel?> fetchUserFromFirestore(
    String userId, BuildContext context) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      final userData = snapshot.data();
      return UserModel.fromJson(userData!);
    } else {
      showMsg(context, 'User does not exist in Firestore');
      print('User does not exist in Firestore');
    }
  } catch (e) {
    showMsg(context, 'Failed to fetch user from Firestore: $e');
    print('Failed to fetch user from Firestore: $e');
  }
  return null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);
  firestore = FirebaseFirestore.instanceFor(app: app);
  messaging = FirebaseMessaging.instance;


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the authentication state is being determined
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return MyHomePage( id: snapshot.data!.uid);
            // User is logged in, navigate to the home screen
          } else {
            // User is not logged in, show the login screen
            return LoginPage();
          }
        },
      ),
    );
  }
}
