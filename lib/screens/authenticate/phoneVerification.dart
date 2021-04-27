import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/sidebarAndScreens/sidebar.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter/services.dart';
import 'package:online_voting/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class PhoneVerification extends StatefulWidget {
  User user;
  bool isPhoneVerified;
  PhoneVerification({this.user,this.isPhoneVerified});
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState(user: user,isPhoneVerified: isPhoneVerified);
}

class _PhoneVerificationState extends State<PhoneVerification> {

  User user;
  String smsOTP = '';
  String verificationId;
  bool isPhoneVerified;
  FirebaseAuth _auth1 = FirebaseAuth.instance;
  _PhoneVerificationState({this.user,this.isPhoneVerified});
  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    try {
      await _auth1.verifyPhoneNumber(
          phoneNumber: '+91'+user.mobileNo, // PHONE NUMBER TO SEND OTP
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(isPhoneVerified),
        ),
        backgroundColor: Colors.black,
        title: Text('Phone Verification'),
      ),
      endDrawer: SideDrawer(user: user,context: context,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: SizedBox(height: 25,),),
            SizedBox(
              width: 300,
              child: TextFormField(
                initialValue: user.mobileNo,
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
          ],
        ),
      )
    );
  }
}
