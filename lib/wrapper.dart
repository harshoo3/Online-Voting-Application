import 'package:flutter/material.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/authenticate/authenticate.dart';
import 'package:online_voting/screens/home/home.dart';
import 'package:online_voting/screens/authenticate/signIn.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    if (user == null){
      return Authenticate();
    }else {
      return Home();
    }
  }
}
