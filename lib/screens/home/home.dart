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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  String name = '';
  String email = '';
  DateTime dateOfBirth;

  @override
  void initState(){
    super.initState();
    _getUserDetails();
  }
  Future<void> _getUserDetails() async {
    Firestore.instance
        .collection('userdata')
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data['name'].toString();
        email = value.data['email'].toString();
        dateOfBirth = DateTime.parse(value.data['dateOfBirth'].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserDetails();
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDetails(name: name,email:email,dateOfBirth:dateOfBirth)));
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: Voting(),
              )
            ],
          ),
      ),
    );
  }
}

