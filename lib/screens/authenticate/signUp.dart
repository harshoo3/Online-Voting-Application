import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/services/auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  String name = '';
  DateTime dateOfBirth ;
  bool isDateEmpty = false;
  // bool phoneNumber =
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return loading? Loading():Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? 'Invalid. Please enter your name':null,
                      onChanged: (val){
                        setState(() {
                          name = val;
                        });
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          suffixIcon: Icon(Icons.account_circle_outlined),
                          hintText: "Name...",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 25,
                // ),
                // SizedBox(
                //   width: 300,
                //   child: InternationalPhoneNumberInput(
                //     onInputChanged: (PhoneNumber number) {
                //       print(number.phoneNumber);
                //     },
                //     onInputValidated: (bool value) {
                //       print(value);
                //     },
                //     selectorConfig: SelectorConfig(
                //       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                //       useEmoji: false,
                //     ),
                //     ignoreBlank: false,
                //     autoValidateMode: AutovalidateMode.disabled,
                //     selectorTextStyle: TextStyle(color: Colors.black),
                //     initialValue: number,
                //     formatInput: false,
                //     inputDecoration: InputDecoration(
                //       suffixIcon: Icon(Icons.phone_android_outlined),
                //       hintText: 'Mobile number...',
                //     ),
                //     spaceBetweenSelectorAndTextField: 0,
                //     keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                //     inputBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                //     onSaved: (PhoneNumber number) {
                //       print('On Saved: $number');
                //     },
                //   ),
                // ),
                SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty? 'Invalid. Please enter an email':null,
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.email_outlined),
                        hintText: "Email...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25,),
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
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) => isDateEmpty ? 'Invalid. Enter Date of birth' : null,
                    onDateSelected: (DateTime val) {
                      setState(() {
                        dateOfBirth = val;
                        isDateEmpty = false;
                        print(DateFormat('yyyy-MM-dd').format(val));
                      });
                    },
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.length < 6 ? 'Invalid. Please enter a password with 6+ chars':null,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                    obscureText: !_showPassword,
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
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  width: 300,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(accentColor: Colors.yellowAccent),
                    child: TextFormField(
                      validator: (val) => val!= password ? "Invalid. Passwords don't match":null,
                      onChanged: (val){
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      obscureText: !_showConfirmPassword,
                      // autofocus: true,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            color: _showConfirmPassword? Colors.red: null,
                            icon: Icon(Icons.remove_red_eye_outlined),
                            onPressed: (){
                              setState(() {
                                _showConfirmPassword=!_showConfirmPassword;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Confirm Password...",
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                    ),
                  ),
                ),
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

                      onPressed: () async{
                        // isDateEmpty(dateOfBirth);
                        if(dateOfBirth == null){
                          setState(() {
                            isDateEmpty = true;
                          });
                        }
                        if(_formkey.currentState.validate()){

                          email = email.trimRight();
                          password = password.trimRight();
                          name = name.trimRight();
                          confirmPassword = confirmPassword.trimRight();
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.registerWithEmailAndPassword(email,password,name,dateOfBirth);
                          loading = false;
                          if(result == null){
                            setState(() {
                              error = 'Please enter a valid Email';
                            });
                          }else{
                            Navigator.pop(context);
                          }
                          // }else{
                          //   await result.sendEmailVerification();
                          // }
                        }
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Register".toUpperCase(),
                          style: TextStyle(fontSize: 19)),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
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

