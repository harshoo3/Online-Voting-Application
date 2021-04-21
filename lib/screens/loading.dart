import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
class Loading extends StatefulWidget {
  Duration duration;
  Loading({this.duration});
  @override
  _LoadingState createState() => _LoadingState(duration:duration);
}

class _LoadingState extends State<Loading> {
  Duration duration;
  _LoadingState({this.duration});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(duration!=null){
      Timer(
          duration,
              (){
            Navigator.pop(context);
          });
    }
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: SpinKitRing(
            color: Colors.black,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
