import 'package:flutter/material.dart';
import 'package:online_voting/models/changeDetailsVerification.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/authenticate/authenticate.dart';
import 'package:online_voting/screens/home/home.dart';
import 'package:online_voting/screens/authenticate/signIn.dart';
import 'package:online_voting/screens/authenticate/signUp.dart';
import 'package:online_voting/screens/loading.dart';
import 'package:online_voting/services/auth.dart';
import 'package:online_voting/wrapper.dart';
import 'package:online_voting/screens/accountDetailsList.dart';
import 'package:provider/provider.dart';
import 'package:online_voting/models/accountDetails.dart';
//
// void main() {
//   runApp(MaterialApp(
//     title: 'Ninja Trips',
//     initialRoute: '/home',
//     routes: {
//       '/home': (context) => Home(),
//       '/signup': (context) => SignUp(),
//     },
//   ));
// }

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSerif'),
        home: Wrapper(),
        title: 'Ninja Trips',
        // initialRoute: '/wrapper',
        routes: {
          '/authenticate':(context) => Authenticate(),
          '/home':(context) => Home(),
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/wrapper': (context) => Wrapper(),
          '/loading': (context) => Loading(),
          '/accountDetails': (context) => AccountDetails(),
          '/changeDetailsVerification': (context) => ChangeDetailsVerification(),
        },
      ),
    );
  }
}