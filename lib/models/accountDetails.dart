import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/services/auth.dart';

class AccountDetails extends StatefulWidget {

  // AccountDetails({ this.name,this.email,this.dateOfBirth});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  String name = '';
  String email = '';
  String dateOfBirth = '';
  // final myController = TextEditingController().text = ;

  void initState() {
    super.initState();
    _getUserName();
    // _getUserName();
  }
  // @override
  // void dispose() {
  //
  //   myController.dispose();
  //   super.dispose();
  // }
  // _printLatestValue() {
  //   print("Second text field: ${myController.text}");
  // }


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
            Center(
              child: Text(
                'name : $name\nemail : $email\ndate of birth : $dateOfBirth ',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            // SizedBox(height: 25,),
            // SizedBox(
            //   width: 350,
            //   child: TextField(
            //     controller: myController,
            //     readOnly: true,
            //     // initialValue: "$dateOfBirth",
            //     obscureText: false,
            //     decoration: InputDecoration(
            //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            //         suffixIcon: Icon(Icons.email_outlined),
            //         border:
            //         OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            //     ),
            //   ),
            // ),
            // SizedBox(height: 25,),
            // SizedBox(
            //   width: 300,
            //   child: TextFormField(
            //
            //     readOnly: true,
            //     initialValue: "$name",
            //     obscureText: false,
            //     decoration: InputDecoration(
            //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            //         suffixIcon: Icon(Icons.account_circle_outlined),
            //         border:
            //         OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
            //   ),
            // ),
            // SizedBox(
            //   width: 350,
            //   child: TextFormField(
            //     readOnly: true,
            //     initialValue: "$dateOfBirth",
            //     enabled: false,
            //     obscureText: false,
            //     decoration: InputDecoration(
            //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            //         suffixIcon: Icon(Icons.email_outlined),
            //         border:
            //         OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 350,
              child: TextFormField(
                // readOnly: true,
                initialValue: "$dateOfBirth",
                // enabled: false,
                obscureText: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    suffixIcon: Icon(Icons.email_outlined),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: FlatButton(
                color: Colors.black,
                child: Text(
                  'Change details',
                ),
                // onPressed: () {
                //   updateData(email:email,name:name);
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
