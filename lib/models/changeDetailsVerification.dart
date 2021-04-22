import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
class ChangeDetailsVerification extends StatefulWidget {

  bool changeDetails ;
  String email;
  ChangeDetailsVerification({this.changeDetails,this.email});
  @override
  _ChangeDetailsVerificationState createState() => _ChangeDetailsVerificationState(changeDetails: changeDetails,email:email);
}

class _ChangeDetailsVerificationState extends State<ChangeDetailsVerification> {

  AuthService _auth= AuthService();
  FirebaseUser currUser;
  String email;
  String text='';
  String typedPassword = '';
  bool _showPassword = false;
  bool changeDetails;
  _ChangeDetailsVerificationState({this.changeDetails,this.email});

  void getUser()async{
    await FirebaseAuth.instance.currentUser().then((value){
      setState(() {
        currUser = value;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  Future<bool> validatePassword(String typedPassword,String email)async {
    // print(user);
    try{
      AuthCredential authCredentials = EmailAuthProvider.getCredential(
        email: email,
        password: typedPassword,
      );
      print(email);
      print(typedPassword);
      print(currUser);
      // AuthResult result1 = await user.reauthenticateWithCredential(credential)
      dynamic result= await currUser.reauthenticateWithCredential(authCredentials);
      // debugger();
      // print(result.additionalUserInfo);
      print('hi2');
      return result!=null;
    }catch(e){
      print(e);
      return false;
    }

    //     .then((value) {
    //   setState(() {
    //     this.text = 'User verification completed';
    //     this.changeDetails = true;
    //   });
    //   return true;
    // }).catchError((){
    //   setState(() {
    //     this.text = 'Passwords not matched';
    //   });
    //   return false;
    // });
    // return false;
    // .catchError({
    //   setState(() {
    //     this.text = 'Passwords not matched';
    //   });
    //   return false;
    // });
    // await user.reauthenticateWithCredential(authCredentials);
    // print(result.user.email);
    // return result.user != null;
  }
  Future<bool> verifyPassword (String typedPassword,String email)async{
    try{
      bool ans = await validatePassword(typedPassword,email);
      if(ans){
        setState(() {
          this.text = 'User verification completed';
          this.changeDetails = true;
        });
        return true;
      }else{
        setState(() {
          this.text = 'Passwords not matched';
        });
        return false;
      }
    } catch(e){
      print(e);

      return false;
    }
  }
  Future<bool>onWillPop()async{
    await Timer(
        Duration(seconds: 1),
            (){
          return Navigator.of(context).pop(false);
        });
  }
  @override
  Widget build(BuildContext context) {
    getUser();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Verification'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25.0),
              Center(
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    readOnly: true,
                    initialValue: '$email',
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
              SizedBox(height: 25.0),
              SizedBox(
                width: 300,
                child: TextFormField(
                  onChanged: (val){
                    setState(() {
                      typedPassword = val;
                    });
                  },
                  obscureText: !_showPassword,
                  validator: (val) => val.isEmpty ? 'Invalid. Please enter your password':null,
                  // autofocus: true,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        color: _showPassword? Colors.red: null,
                        icon: Icon(Icons.remove_red_eye_outlined),
                        onPressed: (){
                          setState(() {
                            _showPassword=!_showPassword;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password...",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
              SizedBox(height: 25.0),
              SizedBox(
                height: 45,
                width: 150,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    // side: BorderSide(color: Colors.red)
                  ),

                  // onPressed: () async{
                  //   print(email);
                  //   print(password);
                  // },
                  onPressed: ()async{
                    if(await verifyPassword(typedPassword,email)){
                      // Duration(seconds: 1);
                      Navigator.pop(context,true);
                    }
                  },
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text("Verify".toUpperCase(),
                      style: TextStyle(fontSize: 19)),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: changeDetails? Colors.green:Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
