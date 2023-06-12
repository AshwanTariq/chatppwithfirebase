import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_screen.dart';

class UserListScreen extends StatefulWidget {
  final String currentUser;
  final String currentUserName;


  const UserListScreen({required this.currentUser,required this.currentUserName,});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isNotEqualTo: widget.currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final userData = userList[index].data() as Map<String, dynamic>;
              final String name = userData['name'];
              final String otherId = userData['id'];
              final String otherToken = userData['fcmToken'];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(name[0]),
                ),
                title: Text(name),
                onTap: (){

                  print("CuserId : ${widget.currentUser}\n");
                  print("CotherId : ${otherId}\n");
                  print("currentUserName : ${widget.currentUserName}\n");
                  print("Cother : ${name}\n");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        otherToken:otherToken,
                        myUserId: widget.currentUser,
                        otherUserId: otherId,
                        myUserName: widget.currentUserName,
                        otherUserName: name,
                      ),),);
                },
              );
            },
          );
        },
      ),
    );
  }
}