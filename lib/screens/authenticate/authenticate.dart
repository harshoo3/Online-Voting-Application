import 'package:flutter/material.dart';
import 'file:///C:/Users/harsh/AndroidStudioProjects/online_voting/lib/screens/authenticate/signIn.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}
