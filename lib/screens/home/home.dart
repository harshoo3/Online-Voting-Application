// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/home/voting.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_voting/screens/accountDetailsList.dart';
import 'package:online_voting/models/accountDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/home/createElection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  String name = '';
  String email = '';
  DateTime dateOfBirth;
  String userType;
  String mobileNo;

  // User user;
  FirebaseUser user;
  @override
  void initState(){
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    // user = await _auth.getCurrentUser()
   this.user =  await FirebaseAuth.instance.currentUser();
    // print(user.email);
    Firestore.instance
        .collection('dataset')
        .document(user.email)
        .get()
        .then((value) {
      setState(() {
        this.name = value.data['name'].toString();
        this.email = value.data['email'].toString();
        this.dateOfBirth = DateTime.parse(value.data['dateOfBirth'].toString());
        this.mobileNo = value.data['mobileNo'].toString();
        this.userType = value.data['userType'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserDetails();

    // StreamProvider<List<AccountDetails>>.value(
    // value: DatabaseService().data,
    // child:
    return Scaffold(
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
              Center(
                child: Text(
                  'Home page',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                child:Text(
                  'Welcome $name',
                  // 'yolo',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: 300,
                child: FlatButton(
                  color: Colors.black,
                  child:Text(
                    'Account details',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDetails(name: name,email: email,dateOfBirth: dateOfBirth,mobileNo: mobileNo,userType: userType)));
                  },
                ),
              ),
              // userType == 'can'?SizedBox(
              //   width: 200,
              //   child: Voting(),
              // ):null,
              // userType == 'org'?SizedBox(
              //   width: 200,
              //   child: CreateElection(),
              // ):null,
              SizedBox(
                width: 300,
                child: FlatButton(
                  color: Colors.black,
                  child:Text(
                    'Add Manifesto',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddManifesto()));
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}

