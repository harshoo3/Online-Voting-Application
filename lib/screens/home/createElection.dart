import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/screens/loading.dart';


class CreateElection extends StatefulWidget {
  String name;
  int electionCount;
  CreateElection({this.name,this.electionCount});

  @override
  _CreateElectionState createState() => _CreateElectionState(name:name,electionCount: electionCount);
}

class _CreateElectionState extends State<CreateElection> {

  final _formkey = GlobalKey<FormState>();
  DateTime startDate,endDate;
  DateTime setDate = new DateTime.now();
  bool loading = false;
  String name;
  int electionCount;
  bool isPressed = false;
  bool isStartDateEmpty = false;
  bool isEndDateEmpty = false;
  bool success = false;
  String errorText = '';

  _CreateElectionState({this.name,this.electionCount});
  FirebaseUser user;
  Future<void> createElectionDatabase(DateTime startDate,DateTime endDate) async {

    // = new DateTime(now.year, now.month, now.day);
    user = await FirebaseAuth.instance.currentUser();
    final CollectionReference elec = Firestore.instance.collection('Elections');
    await elec.document(name).updateData({
      '$electionCount':{
        'setDate': setDate,
        'startDate': startDate,
        'endDate': endDate,
      }
    });
    electionCount=electionCount+1;
    final CollectionReference userdata = Firestore.instance.collection('dataset');
    return await userdata.document(user.email).updateData({
      'electionCount':electionCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      errorText = success?'Success':'Failure';
    });
    return loading? Loading():Scaffold(
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
                      hintText: 'Election Start Date...',
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
                      hintText: 'Election End Date...',
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
                    onPressed: (){
                      setState(() {
                        isPressed = true;
                      });
                      if(startDate == null){
                        setState(() {
                          isStartDateEmpty = true;
                        });
                      }
                      if(endDate == null){
                        setState(() {
                          isEndDateEmpty = true;
                        });
                      }
                      if(startDate.difference(setDate) >= Duration(seconds: 0))
                      if(endDate.difference(startDate) >= Duration(seconds: 0)){
                        if(_formkey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          createElectionDatabase(startDate,endDate);
                          setState(() {
                            loading = false;
                            success = true;
                          });
                        }
                      }
                    },
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
