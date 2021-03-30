import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/models/user.dart';
import 'package:flutter/services.dart';


class CreateElection extends StatefulWidget {
  User user;
  CreateElection({this.user});

  @override
  _CreateElectionState createState() => _CreateElectionState(user:user);
}

class _CreateElectionState extends State<CreateElection> {

  final _formkey = GlobalKey<FormState>();
  DateTime startDate,endDate;
  DateTime setDate = new DateTime.now();
  bool loading = false;
  User user;
  bool isPressed = false;
  bool isStartDateEmpty = false;
  bool isEndDateEmpty = false;
  bool isPartyModeAllowed = false;
  String post = '' ;
  String electionDescription = '';
  int maxCandidates;
  bool success = false;
  String errorText = '';

  _CreateElectionState({this.user});
  Future<void> createElectionDatabase(DateTime startDate,DateTime endDate) async {

    // = new DateTime(now.year, now.month, now.day);
    final CollectionReference elec = Firestore.instance.collection('Elections');
    await elec.document(user.name).updateData({
      '${user.electionCount}':{
        'setDate': setDate,
        'startDate': startDate,
        'endDate': endDate,
        'post': post,
        'electionDescription': electionDescription,
        'maxCandidates':maxCandidates,
        'isPartyModeAllowed':isPartyModeAllowed,
      }
    });
    user.electionCount=user.electionCount+1;
    final CollectionReference userdata = Firestore.instance.collection('dataset');
    return await userdata.document(user.email).updateData({
      'electionCount':user.electionCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      errorText = success?'Success':'Failure';
    });
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Elections'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child:Column(
              children: [
                Center(child: SizedBox(height: 25.0)),
                SizedBox(
                  width: 300,
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Election Start Date...',
                    ),
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) => isStartDateEmpty ? 'Invalid. Enter Date of birth' : null,
                    onDateSelected: (DateTime val) {
                      setState(() {
                        startDate = val;
                        isStartDateEmpty = false;
                        // print( DateFormat('yyyy-MM-dd').format(val));
                      });
                    },
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: 300,
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Election End Date...',
                    ),
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) => isEndDateEmpty ? 'Invalid. Enter Date of birth' : null,
                    onDateSelected: (DateTime val) {
                      setState(() {
                        endDate = val;
                        isEndDateEmpty = false;
                        // print( DateFormat('yyyy-MM-dd').format(val));
                      });
                    },
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty? 'Invalid. Please enter the post for election':null,
                    onChanged: (val){
                      setState(() {
                        post = val;
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.email_outlined),
                        labelText: "The Post for election...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),SizedBox(height: 25,),
                SizedBox(
                  width: 270,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Is Party system allowed?'),
                      CupertinoSwitch(
                        activeColor: Colors.blue,
                        value: isPartyModeAllowed,
                        onChanged: (value) {
                          print("VALUE : $value");
                          setState(() {
                            isPartyModeAllowed = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty? 'Invalid. Please enter the maximum number of Candidates':null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val){
                      setState(() {
                        maxCandidates = int.parse(val);
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.person),
                        labelText: "The Max number of Candidates...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: 300,
                  height: 140,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                    validator: (val) => val.isEmpty? 'Invalid. Please enter the post for election':null,
                    onChanged: (val){
                      setState(() {
                        electionDescription = val;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.edit),
                        labelText: "Election Description...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
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
                    onPressed: () {
                      setState(() {
                        isPressed = true;
                      });
                      if (startDate == null) {
                        setState(() {
                          isStartDateEmpty = true;
                        });
                      }
                      if (endDate == null) {
                        setState(() {
                          isEndDateEmpty = true;
                        });
                      }
                      if (startDate.difference(setDate) >= Duration(seconds: 0)) {
                        if (endDate.difference(startDate) >= Duration(seconds: 0)) {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            createElectionDatabase(startDate, endDate);
                            setState(() {
                              loading = false;
                              success = true;
                            });
                          }
                        }
                      }
                    }
                  ),
                ),
                isPressed?SizedBox(
                  width: 300,
                  child: Text(
                    errorText,
                    style: TextStyle(
                      color: success?Colors.green:Colors.red,
                    ),
                  )
                ):SizedBox(width: 0,),
              ],
            ),
          ),
        ),
      ),
    );
    }
  }
}
