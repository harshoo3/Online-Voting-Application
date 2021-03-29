import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateElection extends StatefulWidget {
  @override
  _CreateElectionState createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {

  FirebaseUser user;
  Future<void> createElectionDatabase() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    user = await FirebaseAuth.instance.currentUser();
    final CollectionReference elec = Firestore.instance.collection('Elections');
    await elec.document(user.email).setData({
      'set-date':date,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          color:Colors.black,
          child: Text(
            'Create Election'
          ),
          onPressed: (){
            createElectionDatabase();
          },
        ),
      ],
    );
  }
}
