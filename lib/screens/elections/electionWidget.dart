import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/models/user.dart';
import 'package:online_voting/screens/elections/organisations/electionScreenOrg.dart';
import 'package:online_voting/screens/elections/voters/electionScreenVot.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:online_voting/screens/elections/candidates/electionScreenCan.dart';
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
  CustomMethods _customMethods = CustomMethods();
  _ElectionWidgetState({this.election,this.user});


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
              if(user.userType == 'can'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenCan(election:election,user:user)));
              }else if(user.userType == 'org'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenOrg(election:election,user:user)));
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectionScreenVot(election:election,user:user)));
              }

            },
            color: Colors.black,
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
                      'Post:   ${election.post}',
                      style: TextStyle(
                        fontSize: 20,
                        color:Colors.white,
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
                        color: Colors.white,
                        size: 19,
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US').format(election.startDate).toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                      Text(
                        DateFormat.yMMMMd('en_US').format(election.endDate).toString(),
                        style: TextStyle(
                            fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  width: 100.0,
                  lineHeight: 14.0,
                  percent: _customMethods.calculatePercent(election),
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
