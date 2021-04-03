import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
class ElectionScreen extends StatefulWidget {
  ElectionClass election;
  ElectionScreen({this.election});
  @override
  _ElectionScreenState createState() => _ElectionScreenState(election:election);
}

class _ElectionScreenState extends State<ElectionScreen> {
  ElectionClass election;
  _ElectionScreenState({this.election});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
