import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDetails extends StatefulWidget {

  // AccountDetails({ this.name,this.email,this.dateOfBirth});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  String name = '';
  String email = '';
  String dateOfBirth = '';

  void initState() {
    super.initState();
    _getUserName();
    // _getUserName();
  }

  Future<void> _getUserName() async {
    Firestore.instance
        .collection('userdata')
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data['name'].toString();
        email = value.data['email'].toString();
        dateOfBirth = value.data['dateOfBirth'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Account Details'
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              'name : $name\nemail : $email\ndate of birth : $dateOfBirth ',
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ],
        ),
      ),
    );
  }
}
