import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../services/notification_service.dart';

class ChatScreen extends StatefulWidget {
  final String myUserId;
  final String otherUserId;
  final String myUserName;
  final String otherUserName;
  final String otherToken;

  ChatScreen(
      {required this.myUserId,
      required this.otherUserId,
      required this.otherToken,
      required this.myUserName,
      required this.otherUserName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate().toLocal();
    return "${dateTime.hour}: ${dateTime.minute}";
  }

  Future<void> sendNotification(String receiverId, String message, String token) async {
    // Implement your code to send a push notification to the receiver using FCM
    // You can use the Firebase Cloud Messaging REST API or a package like `http` to make the HTTP request
    // Include the receiver's device token or topic and the message content
    // For example:

    final notificationData = {
      'notification': {
        'title': 'New Message by ${widget.myUserName}',
        'body': message,
      },
      "data": {
        'sender': widget.myUserId,
        'receiver': widget.otherUserId,
        'receiverName': widget.otherUserName,
        'senderName': widget.myUserName,
        'token': widget.otherToken,
      },
      'to': token,
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAFzH1--U:APA91bEb2IpaBUijnDhoE4PWq-7Yah6u46Y4tcSbjOzV34eCFYmiaY1n6xh1aV5xvB33jgzGSLvFdPTy9F3X5apXt9v1ok0ErhKtJ-g_3-OInkjgHJq5Jl272hWMAI2fsfm85uZmiZ7G',
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy("addTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Start Chat"));
                  }
                }

                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    final chatData =
                        chatDocs[index].data() as Map<String, dynamic>;
                    final String sender = chatData['sender'];
                    final String receiver = chatData['receiver'];
                    final String senderName = chatData['senderName'];
                    final String message = chatData['message'];
                    final Timestamp time = chatData['addTime'] as Timestamp;
                    final bool isCurrentUser = sender == widget.myUserId &&
                        receiver == widget.otherUserId;
                    final bool isOtherUser = sender == widget.otherUserId &&
                        receiver == widget.myUserId;

                    if (isCurrentUser || isOtherUser) {
                      if (isCurrentUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          formatTimestamp(time),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          formatTimestamp(time),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }

                    return SizedBox
                        .shrink(); // Add this line to hide unwanted messages
                  },
                );

                /* return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    final chatData =
                        chatDocs[index].data() as Map<String, dynamic>;
                    final String sender = chatData['sender'];
                    final String receiver = chatData['receiver'];
                    final String senderNAme = chatData['senderName'];
                    final String message = chatData['message'];
                    final Timestamp time = chatData['addTime'] as Timestamp;
                    final bool isCurrentUser = sender == widget.myUserId;

                    if(sender==widget.myUserId && receiver==widget.otherUserId){
                      if (isCurrentUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          formatTimestamp(time),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          formatTimestamp(time),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }


                  },
                );*/
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newMessage = _messageController.text.trim();
                    if (newMessage.isNotEmpty) {
                      sendMessage(newMessage);
                      _messageController.clear();
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    try {
      final chatData = {
        'sender': widget.myUserId,
        'receiver': widget.otherUserId,
        'receiverName': widget.otherUserName,
        'senderName': widget.myUserName,
        'message': message,
        'addTime': DateTime.now(),
      };
      await FirebaseFirestore.instance.collection('chats').add(chatData);
      await sendNotification(widget.otherUserId, message, widget.otherToken);
      print('Message sent');
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}
