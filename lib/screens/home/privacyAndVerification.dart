import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/authenticate/emailVerification.dart';
class PrivacyAndVerification extends StatefulWidget {
  User user;
  PrivacyAndVerification({this.user});
  @override
  _PrivacyAndVerificationState createState() => _PrivacyAndVerificationState(user: user);
}

class _PrivacyAndVerificationState extends State<PrivacyAndVerification> {
  User user;
  bool isEmailVerified;
  FirebaseUser currUser;
  _PrivacyAndVerificationState({this.user});

  Future<void> getVerificationDetails() async {
    // user = await _auth.getCurrentUser()
    this.currUser = await FirebaseAuth.instance.currentUser();
    this.isEmailVerified = currUser.isEmailVerified;
  }

  @override
  void initState() {
    // TODO: implement initState
    getVerificationDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Privacy and Verification'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            child: FlatButton(
              color: Colors.black,
              child:Text(
                'Email Verification',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: ()async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerification(user:user,isEmailVerified: isEmailVerified,))).
                then((value){
                  setState(() {
                    isEmailVerified = true;
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
