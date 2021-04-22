import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/sidebarAndScreens/accountDetails.dart';
import 'package:online_voting/screens/home/home.dart';
import 'package:online_voting/services/auth.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/sidebarAndScreens/privacyAndVerification.dart';
import 'package:online_voting/screens/loading.dart';

class SideDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User user;
  BuildContext context;
  bool home = false;
  SideDrawer({this.user,this.context,this.home = false});
  @override
  Widget build(context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Hey there, fellow Voter!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text('Home'),
                onTap: () => {Navigator.pushReplacementNamed(context, '/home')},
              ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Account Details'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDetails(user:user))),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacy and Verification'),
                onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyAndVerification(user: user,))),
              ),
            ],
          ),
          ListTile(
            leading: Icon(
                Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            tileColor: Colors.black,
            onTap:  () async{
              Navigator.of(context).popUntil((route) => route.isFirst);
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Loading(duration: Duration(seconds: 2),)));
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}