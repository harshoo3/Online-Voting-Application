// import 'dart:html';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/elections.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // AuthService _auth = AuthService();
  User user;
  FirebaseUser currUser;
  bool loading =true;
  bool returned = false;

  @override
  void initState(){
    getUserDetails();
    super.initState();
  }

  Future<void> getUserDetails() async {
    // await _auth.signOut();
   this.currUser =  await FirebaseAuth.instance.currentUser();
   // print(currUser.isEmailVerified);
   //  print(user.email);
    print(currUser.email);
    await Firestore.instance.collection('dataset').document(currUser.email).get().then((value) {
      print(value.data['userType'].toString());
      setState(() {
        user= User(
            userType:value.data['userType'].toString(),
            name:value.data['name'].toString(),
            email:value.data['email'].toString(),
            dateOfBirth:DateTime.parse(value.data['dateOfBirth'].toString()),
            mobileNo:value.data['mobileNo'].toString(),
            orgName:value.data['orgName'].toString(),
            electionCount:value.data['electionCount'],
        );
        loading = false;
      });
      return user.orgName;
    }).then((value)async{
      await Firestore.instance.collection('Elections').document(value).get().then((val)async{
        setState(() {
          user.totalVoters = val.data['totalVoters'];
        });
        print(user.totalVoters);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(returned);
    // StreamProvider<List<AccountDetails>>.value(
    // value: DatabaseService().data,
    // child:
    return loading? Loading():Scaffold(
      endDrawer: SideDrawer(user: user,context: context,home: true,),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('VoteHub'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                    'Welcome ${user.name}',
                    // 'yolo',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: FlatButton(
                    color: Colors.black,
                    child:Text(
                      'Elections',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Elections(user:user)));
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

