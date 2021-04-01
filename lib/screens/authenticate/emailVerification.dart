import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/models/user.dart';
class EmailVerification extends StatefulWidget {
  User user;
  EmailVerification({this.user});
  @override
  _EmailVerificationState createState() => _EmailVerificationState(user: user);
}


class _EmailVerificationState extends State<EmailVerification> {

  User user;
  FirebaseUser currUser;
  Timer timer;
  bool isEmailVerified = false;
  _EmailVerificationState({this.user});
  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    verifyEmail();
    super.initState();
  }
  Future<void>verifyEmail()async{
    currUser =  await FirebaseAuth.instance.currentUser();
    currUser.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // print('timer');
      checkEmailVerified();
    });
  }
  Future<void>checkEmailVerified()async{
    // print('checking');
    await currUser.reload();
    currUser =  await FirebaseAuth.instance.currentUser();
    // print(currUser.email);
    // print(currUser.isEmailVerified);
    if(currUser.isEmailVerified){
      // print('verified');
      timer.cancel();
      setState(() {
        isEmailVerified = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(isEmailVerified),
        ),
        backgroundColor: Colors.black,
        title: Text('Create Elections'),
      ),
      body: Center(
        child:!isEmailVerified?
        Text('An email has been sent to your email address ${user.email}.'):
        Text('Your email address has been verified'),
      ),
    );
  }
}
