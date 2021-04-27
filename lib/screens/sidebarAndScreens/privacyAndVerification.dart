import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/authenticate/emailVerification.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:online_voting/screens/authenticate/phoneVerification.dart';
class PrivacyAndVerification extends StatefulWidget {
  User user;
  PrivacyAndVerification({this.user});
  @override
  _PrivacyAndVerificationState createState() => _PrivacyAndVerificationState(user: user);
}

class _PrivacyAndVerificationState extends State<PrivacyAndVerification> {
  User user;
  bool isEmailVerified;
  bool isPhoneVerified = false;
  FirebaseUser currUser;
  bool detailsFetched = false;
  _PrivacyAndVerificationState({this.user});

  Future<void> getVerificationDetails() async {
    // user = await _auth.getCurrentUser()
    this.currUser = await FirebaseAuth.instance.currentUser();
    this.isEmailVerified = currUser.isEmailVerified;
    setState(() {
      detailsFetched =true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getVerificationDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !detailsFetched?Loading():Scaffold(
      appBar: customAppBar(
          title:'Privacy and Verification',
          context: context
      ),
      endDrawer: SideDrawer(user: user,context: context),
      body: Column(
        children: [
          Center(child: SizedBox(height: 25,)),
          SizedBox(
            width: 250,
            height: 50,
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
          SizedBox(height: 25,),
          SizedBox(
            width: 250,
            height: 50,
            child: FlatButton(
              color: Colors.black,
              child:Text(
                'Phone Verification',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: ()async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerification(user:user,isPhoneVerified: isPhoneVerified,))).
                then((value){
                  setState(() {
                    isPhoneVerified = true;
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
