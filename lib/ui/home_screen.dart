import 'package:fab_tech_chat_app/main.dart';
import 'package:fab_tech_chat_app/ui/chat_screen.dart';
import 'package:fab_tech_chat_app/ui/users_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import '../services/notification_service.dart';
import '../utils/splash.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.id});

  final String id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late final UserModel user;

  void askPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void logOut() async {
    await auth.signOut();
  }

  @override
  void initState() {
    NotificationService.initializeNotifications(context);
    super.initState();
  }

  final String currentUser = "T0KfGRkH8xXrMRukaUSE6VqP5yT2";
  final String otherUser = "GUZVN5qMsmPQv0OOIb5T7NTqMhH2";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Chat App"),
        actions: [
          IconButton(onPressed: logOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<UserModel?>(
          future: fetchUserFromFirestore(widget.id, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                user = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Hi , ${user.name}",style: TextStyle(fontSize: 40),),
                      /*FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    myUserId: currentUser,
                                        otherUserId: otherUser,
                                    myUserName: 'Ashwan tariq',
                                        otherUserName: 'Saad Subhani',
                                      )));
                        },
                        tooltip: 'Ashwan',
                        child: const Icon(Icons.abc_outlined),
                      ),
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    myUserId: otherUser,
                                        otherUserId: currentUser,
                                    myUserName: 'Saad Subhani',
                                        otherUserName: 'Ashwan tariq',
                                      ),),);
                        },
                        tooltip: 'Saad',
                        child: const Icon(Icons.access_alarm_outlined),
                      ),*/
                    ],
                  ),
                );
              } else {
                return SplashScreen(
                  status: 'no data',
                );
              }
            }
            return SplashScreen(
              status: 'Issue',
            );
          }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserListScreen(
                        currentUser: user.id, currentUserName: user.name,
                      )));
        },
        tooltip: 'Chat',
        child: const Icon(Icons.chat),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
