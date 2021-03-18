import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/services/auth.dart';
import 'package:smart_select/smart_select.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _showPassword = false;

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  //text field state
  String email = '';
  String password = '';
  String text1 = '';
  bool loading = false;
  String userType = null;
  bool isUserTypeEmpty = false;

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return loading ? Loading():Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: SmartSelect<String>.single(
                        title:'User type',
                        modalValidation: (val) => isUserTypeEmpty? 'Invalid. Please enter your User type':null,
                        modalType: S2ModalType.popupDialog,
                        // modalConfig: S2ModalConfig(
                        //   confirmColor: Colors.green,
                        //   barrierColor: Colors.pink,
                        // ),
                        modalHeaderStyle: S2ModalHeaderStyle(
                            backgroundColor: Colors.black,
                            centerTitle: true,
                            iconTheme: IconThemeData(
                              color: Colors.white, //change your color here
                            ),
                            textStyle: TextStyle(
                              color: Colors.white,
                            )
                        ),
                        // The text displayed when the value is null
                        placeholder :'Select one',
                        choiceStyle: S2ChoiceStyle(
                          activeColor: Colors.black,
                        ),
                        // The current value of the single choice widget.
                        value:userType,
                        // Called when single choice value changed
                        onChange: (state) => setState((){
                          userType = state.value;
                          isUserTypeEmpty = false;
                        }),

                        // choice item list
                        choiceItems: [
                          S2Choice<String>(value: 'vot', title: 'Voter'),
                          S2Choice<String>(value: 'can', title: 'Candidate'),
                          S2Choice<String>(value: 'org', title: 'Organisation'),
                        ],
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
                        email = val;
                      });
                    },
                    validator: (val) => val.isEmpty? 'Invalid. Please enter an email':null,
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.email_outlined),
                        hintText: "Email...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                    obscureText: !_showPassword,
                    validator: (val) => val.isEmpty? 'Invalid. Please enter your password':null,
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
                // SizedBox(
                //   height: 75.0,
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
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
                      onPressed: () async{
                        if(userType == null){
                          setState(() {
                            isUserTypeEmpty = true;
                          });
                        }
                        email = email.trimRight();
                        password = password.trimRight();
                        if(_formkey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });

                          dynamic result = await _auth.loginWithEmailAndPassword(email,password,userType);
                          print(result);
                          if(result == null){
                            print('3');
                            setState(() {
                              text1 = 'Incorrect username,user type or password';
                              loading = false;
                            });
                          }
                        }
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("login".toUpperCase(),
                          style: TextStyle(fontSize: 19)),
                    ),
                  ),
                ),
                Text(
                  text1,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "If you haven't registered yet?"
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 45,
                      //   width: 150,
                      //   child: RaisedButton(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(18.0),
                      //       // side: BorderSide(color: Colors.red)
                      //     ),
                      //
                      //     onPressed: () async {
                      //       Navigator.pushNamed(context, '/loading');
                      //       dynamic result = await _auth.signInAnon();
                      //       Navigator.pop(context);
                      //       if(result == null){
                      //         print('error signing in');
                      //       } else {
                      //         print('signed in');
                      //         print(result.uid);
                      //       }
                      //
                      //     },
                      //     color: Colors.black,
                      //     textColor: Colors.white,
                      //     child: Text("guest".toUpperCase(),
                      //         style: TextStyle(fontSize: 19)),
                      //   ),
                      // ),
                      SizedBox(
                        height: 45,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.red)
                          ),

                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text("Sign Up".toUpperCase(),
                              style: TextStyle(fontSize: 19)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Online Voting',
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
    );
  }
}
