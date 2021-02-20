import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/services/auth.dart';

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
                  padding: const EdgeInsets.only(top: 20,bottom: 30),
                  child: Center(
                    child: Image.asset(
                      'images/id-card2.jpg',
                      height: 300,
                    ),
                  ),
                ),
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
                        email = email.trimRight();
                        password = password.trimRight();
                        if(_formkey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.loginWithEmailAndPassword(email,password);
                          if(result == null){
                            setState(() {
                              text1 = 'Incorrect username or password';
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
                      SizedBox(
                        height: 45,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.red)
                          ),

                          onPressed: () async {
                            Navigator.pushNamed(context, '/loading');
                            dynamic result = await _auth.signInAnon();
                            Navigator.pop(context);
                            if(result == null){
                              print('error signing in');
                            } else {
                              print('signed in');
                              print(result.uid);
                            }

                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text("guest".toUpperCase(),
                              style: TextStyle(fontSize: 19)),
                        ),
                      ),
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
