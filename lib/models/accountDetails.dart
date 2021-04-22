import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_voting/customWidgets/custom.dart';
import 'package:online_voting/models/changeDetailsVerification.dart';
import 'package:online_voting/services/auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/services/database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:online_voting/models/user.dart';

class AccountDetails extends StatefulWidget {

  String name,email,mobileNo,userType;
  DateTime dateOfBirth;
  User user;
  AccountDetails({ this.user});

  @override
  _AccountDetailsState createState() => _AccountDetailsState(user:user);
}

class _AccountDetailsState extends State<AccountDetails> {

  final AuthService _auth = AuthService();
  bool _changeDetails = false;
  bool isEmailChanged = false;
  bool error=false;
  User user;
  final _formkey = GlobalKey<FormState>();
  // final _controller = TextEditingController().text = "$name" ;
  // String name,email,mobileNo;
  // DateTime dateOfBirth;

  _AccountDetailsState({ this.user});

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title:'Account Details',
          context: context
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Center(child: SizedBox(height: 25,)),
                _changeDetails?Column(
                  children: [
                    Text('User verification completed.',
                    style: TextStyle(
                      color: Colors.green
                      ),
                    ),
                    SizedBox(height: 25,)
                  ],
                ):SizedBox(),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${user.email}",
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.email_outlined),
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                user.userType!='org'?SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Invalid. Please enter your new name':null,
                    onChanged: (val){
                      val = val.trim();
                      setState(() {
                        user.name = val;
                      });
                    },
                    readOnly: !_changeDetails,
                    initialValue: "${user.name}",
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.account_circle_outlined),
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                ):SizedBox(
                  width: 300,
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${user.name}",
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.account_circle_outlined),
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Invalid. Please enter your new mobile number':null,
                    onChanged: (val){
                      val = val.trim();
                      setState(() {
                        user.mobileNo = val;
                      });
                    },
                    readOnly: !_changeDetails,
                    initialValue: "${user.mobileNo}",
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.phone_android),
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
                    enabled: _changeDetails,
                    initialValue: user.dateOfBirth,
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) => val == null ? 'Invalid. Enter Date of birth' : null,
                    onDateSelected: (DateTime val) {
                      setState(() {
                        user.dateOfBirth = val;
                        // isDateEmpty = false;
                        print(DateFormat('yyyy-MM-dd').format(val));
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _changeDetails?SizedBox(
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
                      if(_formkey.currentState.validate()){
                        dynamic result = await _auth.updateData(email:user.email,dateOfBirth:user.dateOfBirth,mobileNo: user.mobileNo,userType: user.userType);
                        if(result == null){
                          setState(() {
                            error=true;
                          });
                        }else{
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ):SizedBox(
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
                    onPressed: () async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeDetailsVerification(changeDetails:_changeDetails,email: user.email))).then((value) {
                        setState(() {
                          _changeDetails = value;
                        });
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                // Text(
                //   error? 'There has been some error in updating data': 'Task completed Succesfully',
                //   style: TextStyle(
                //     color: error?Colors.red:Colors.blue,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}