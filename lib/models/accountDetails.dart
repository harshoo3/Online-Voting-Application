import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/services/auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/services/database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AccountDetails extends StatefulWidget {

  String name,email,mobileNo;
  DateTime dateOfBirth;
  AccountDetails({ this.name,this.email,this.dateOfBirth,this.mobileNo});

  @override
  _AccountDetailsState createState() => _AccountDetailsState(name: name,email: email,dateOfBirth: dateOfBirth,mobileNo: mobileNo);
}

class _AccountDetailsState extends State<AccountDetails> {

  final AuthService _auth = AuthService();
  bool _changeDetails = true;
  bool isEmailChanged = false;
  bool error=false;
  // final _controller = TextEditingController().text = "$name" ;
  String name,email,mobileNo;
  DateTime dateOfBirth;

  _AccountDetailsState({ this.name,this.email,this.dateOfBirth,this.mobileNo});

  void initState() {
    super.initState();
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
      backgroundColor: _changeDetails? Colors.white:Colors.lightBlue[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25,),
            Center(
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (val) => val.isEmpty ? 'Invalid. Please enter your new email':null,
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                  readOnly: _changeDetails,
                  initialValue: "$email",
                  obscureText: false,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      suffixIcon: Icon(Icons.email_outlined),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
            SizedBox(
              width: 300,
              child: TextFormField(
                validator: (val) => val.isEmpty ? 'Invalid. Please enter your new name':null,
                onChanged: (val){
                  setState(() {
                    name = val;
                  });
                },
                readOnly: _changeDetails,
                initialValue: "$name",
                obscureText: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    suffixIcon: Icon(Icons.account_circle_outlined),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                validator: (val) => val.isEmpty ? 'Invalid. Please enter your new mobile number':null,
                onChanged: (val){
                  setState(() {
                    mobileNo = val;
                  });
                },
                readOnly: _changeDetails,
                initialValue: "$name",
                obscureText: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    suffixIcon: Icon(Icons.account_circle_outlined),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: DateTimeFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  suffixIcon: Icon(Icons.event_note),
                  hintText: 'Date of birth...',
                ),
                enabled: !_changeDetails,
                initialValue: dateOfBirth,
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                validator: (val) => val == null ? 'Invalid. Enter Date of birth' : null,
                onDateSelected: (DateTime val) {
                  setState(() {
                    dateOfBirth = val;
                    // isDateEmpty = false;
                    print(DateFormat('yyyy-MM-dd').format(val));
                  });
                },
              ),
            ),
            // SizedBox(
            //   width: 300,
            //   child: TextFormField(
            //     readOnly: _changeDetails,
            //     // controller: _controller,
            //     initialValue: DateFormat('yyyy-MM-dd').format(dateOfBirth),
            //     // enabled: true,
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
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: FlatButton(
                color: Colors.black,
                // textColor: Colors.blue,
                child: Text(
                  'Change details?',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _changeDetails=!_changeDetails;
                  });
                },
              ),
            ),
            SizedBox(
              width: 300,
              child: FlatButton(
                color: Colors.black,
                // textColor: Colors.blue,
                child: Text(
                  'Update details',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: () async {
                  dynamic result = await _auth.updateData(name:name,email:email,dateOfBirth:dateOfBirth);
                  if(result == null){
                    setState(() {
                      error=true;
                    });
                  }else{
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            SizedBox(height: 10,),
            Text(
              error? 'There has been some error in updating data': 'Task completed Succesfully',
              style: TextStyle(
                color: error?Colors.red:Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
