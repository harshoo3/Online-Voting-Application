import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/screens/accountDetailsList.dart';
import 'package:online_voting/models/accountDetails.dart';
class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<AccountDetails>>.value(
      value: DatabaseService().data,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Online Voting'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async{
                await _auth.signOut();
              },
              label: Text('log out'),
              icon: Icon(Icons.logout),
              textColor: Colors.white,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Text('home'),
              // SizedBox(height: 30,),
              // SizedBox(
              //   width: 300,
              //   child: FlatButton(
              //     child:Text('Account details'),
              //     onPressed: (){
              //       Navigator.pushNamed(context,'/accountDetailsList');
              //     },
              //   ),
              // ),
              AccountDetailsList(),
            ],
          )
        ),
      ),
    );
  }
}
