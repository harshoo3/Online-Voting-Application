import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/home/addManifesto.dart';
import 'package:online_voting/screens/home/createElection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Elections extends StatefulWidget {

  User user;
  Elections({this.user});

  @override
  _ElectionsState createState() => _ElectionsState(user:user);
}

class _ElectionsState extends State<Elections> {

  User user;
  _ElectionsState({this.user});
  getElectionDetails(){
    Firestore.instance
      .collection('Elections')
        .document(user.orgName)
        .get()
        .then((value) {
        
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Elections'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 25,
                ),
              ),
              Text('Ongoing Elections:'),
              SizedBox(
                height: 50,
                // if()
              ),
              SizedBox(height: 25,),
              Text('Upcoming Elections :'),
              SizedBox(

              ),
              user.userType == 'org'?
              SizedBox(
                width: 300,
                child: RaisedButton(
                  color:Colors.black,
                  child: Text(
                    'Create Election',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateElection(user:user)));
                  },
                ),
              ):SizedBox(height: 0,),
              // SizedBox(
              //   height: 25,
              // ),
              user.userType == 'can'?
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
              ):SizedBox(height: 0,),

            ],
          ),
        ),
      ),
    );
  }
}
