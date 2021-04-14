import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/services/auth.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  FirebaseAuth _auth1 = FirebaseAuth.instance;
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String mobileNo = '';
  String error = '';
  String name = '';
  String smsOTP = '';
  String verificationId;
  DateTime dateOfBirth ;
  String orgName = 'Default';
  bool isDateEmpty = false;
  String userType = null;
  int electionCount = 0;
  bool isUserTypeEmpty = false;
  List<DocumentSnapshot> orgNamesDoc;
  List<String> orgNames = ['Default'];
  // bool phoneNumber =
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Future<void> getMarker() async{
    QuerySnapshot snapshot = await Firestore.instance.collection('orgNames').getDocuments();
    orgNamesDoc = snapshot.documents;
    for(var i = 0;i< orgNamesDoc.length;i++){
      print(orgNamesDoc[i].data['name']);
      setState(() {
        orgNames.add(orgNamesDoc[i].data['name']);
      });
    }
    // print(xyz.data);
  }
  Future addOrgName()async{
    final CollectionReference userdata = Firestore.instance.collection('orgNames');
    return await userdata.document(name).setData({
      'name':name,
    });
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    try {
      await _auth1.verifyPhoneNumber(
          phoneNumber: this.mobileNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: null,
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 100),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print('1');
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exception) {
            print('2');
            print('${exception.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }
  handleError(PlatformException error) {
    print('3');
    print(error);
    // switch (error.code) {
    //   case 'ERROR_INVALID_VERIFICATION_CODE':
    //     FocusScope.of(context).requestFocus(new FocusNode());
    //     setState(() {
    //       errorMessage = 'Invalid Code';
    //     });
    //     Navigator.of(context).pop();
    //     smsOTPDialog(context).then((value) {
    //       print('sign in');
    //     });
    //     break;
    //   default:
    //     setState(() {
    //       errorMessage = error.message;
    //     });
    //
    //     break;
    // }
  }
  verifyOTP() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      print('otp verified');
    } catch (e) {
      handleError(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getMarker();
    super.initState();
  }
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
                          labelText: "Name...",
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
                SizedBox(height: 25,),
                userType!= 'org'?SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<String>(
                    hint: Text('Organisation name'),
                    isExpanded: true,
                    value: orgName,
                    icon: Icon(
                      Icons.arrow_downward,
                    ),
                    iconSize: 24,
                    elevation: 16,

                    validator: (value) => value == null ? 'Organisation name required' : null,
                    style: TextStyle(
                        color: Colors.black
                    ),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.black,
                    // ),

                    onChanged: (String newValue) {
                      setState(() {
                        orgName = newValue;
                      });
                    },
                    items: orgNames
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                ):SizedBox(height: 0,),
                SizedBox(
                  height: userType!= 'org'? 25 : 0,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty? 'Invalid. Please enter your Mobile number':null,
                    onChanged: (val){
                      setState(() {
                        mobileNo = val;
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.phone),
                        labelText: "Mobile number...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: (){
                      // setState(() {
                      //   mobileNo = '+91'+mobileNo;
                      //   print(mobileNo);
                      // });
                      verifyPhone();
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text("Send OTP".toUpperCase(),
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: (val) => val.isEmpty? 'Invalid. Please enter your Mobile number':null,
                    onChanged: (val){
                      setState(() {
                        smsOTP = val;
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: Icon(Icons.message_outlined),
                        labelText: "OTP...",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: (){
                      verifyOTP();
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Text("Done".toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                      ),
                    ),
                  ),
                ),
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
                        labelText: "Email...",
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
                      labelText: 'Date of birth...',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) => isDateEmpty ? 'Invalid. Enter Valid Date of birth' :null,
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
                        labelText: "Password...",
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
                          labelText: "Confirm Password...",
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
                        if(userType == null){
                          setState(() {
                            isUserTypeEmpty = true;
                          });
                        }
                        if(_formkey.currentState.validate()){
                          mobileNo = mobileNo.trim();
                          email = email.trim();
                          email = email.toLowerCase();
                          password = password.trim();
                          name = name.trimRight();
                          confirmPassword = confirmPassword.trimRight();
                          setState(() {
                            loading = true;
                          });
                          if(userType == 'org'){
                            orgName = name;
                          }
                          dynamic result = await _auth.registerWithEmailAndPassword(email,password,name,dateOfBirth,mobileNo,userType,orgName,electionCount);
                          loading = false;
                          if(result == null){
                            setState(() {
                              error = 'Please enter a valid Email';
                            });
                          }else{
                            if(userType=='org'){
                              addOrgName();
                            }
                            print(getMarker());
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

