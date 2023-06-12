import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key,required this.status}) : super(key: key);

  final String status;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("CHAT APP \n ${status}",style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
