import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/models/accountDetails.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/screens/home/privacyAndVerification.dart';

class SideDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User user;
  SideDrawer({this.user});
  @override
  Widget build(BuildContext context) {
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

              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}