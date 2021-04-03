import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:online_voting/screens/electionScreen.dart';
class ElectionWidget extends StatefulWidget {
  ElectionClass election;
  ElectionWidget({this.election});
  @override
  _ElectionWidgetState createState() => _ElectionWidgetState(election:election);
}

class _ElectionWidgetState extends State<ElectionWidget> {
  ElectionClass election;
  _ElectionWidgetState({this.election});

  double calculatePercent(ElectionClass election){
    if(election!=null){
      num bigdiff = election.endDate.difference(election.startDate).inSeconds;
      num smalldiff = DateTime.now().difference(election.startDate).inSeconds;
      return (smalldiff/bigdiff);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 300,
        child: ElevatedButton(
          // color: Colors.green,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreen(election:election)));
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          child: LinearPercentIndicator(
            width: 140.0,
            lineHeight: 14.0,
            percent: calculatePercent(election),
            animationDuration: 1000,
            animation: true,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
