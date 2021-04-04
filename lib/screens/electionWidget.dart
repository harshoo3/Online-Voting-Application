import 'package:flutter/material.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:online_voting/screens/electionScreen.dart';
import 'package:intl/intl.dart';
class ElectionWidget extends StatefulWidget {
  User user;
  ElectionClass election;
  ElectionWidget({this.election,this.user});
  @override
  _ElectionWidgetState createState() => _ElectionWidgetState(election:election,user:user);
}

class _ElectionWidgetState extends State<ElectionWidget> {
  ElectionClass election;
  User user;
  _ElectionWidgetState({this.election,this.user});

  double calculatePercent(ElectionClass election){
    if(election!=null){
      num bigdiff = election.endDate.difference(election.startDate).inSeconds;
      num smalldiff = DateTime.now().difference(election.startDate).inSeconds;
      double ans = smalldiff/bigdiff;
      if(ans>1){
        return 1;
      }else if(ans<0){
        return 0;
      }else{
        return ans;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SizedBox(
          height: 150,
          width: 300,
          child: FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreen(election:election,user:user)));
            },
            color: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Post:${election.post}',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 4.0,
                      percent: 0.30,
                      center: new Text("30%"),
                      progressColor: Colors.orange,
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                        size: 19,
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US').format(election.startDate).toString(),
                        style: TextStyle(
                          fontSize: 10
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                        size: 19,
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US').format(election.endDate).toString(),
                        style: TextStyle(
                            fontSize: 10
                        ),
                      ),
                    ],
                  ),
                  width: 100.0,
                  lineHeight: 14.0,
                  percent: calculatePercent(election),
                  animationDuration: 1000,
                  animation: true,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
