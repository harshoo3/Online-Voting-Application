import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:online_voting/screens/elections/countdown.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class ElectionScreenStats extends StatelessWidget {

  ElectionClass election;
  int totalVoters;
  ElectionScreenStats({this.election,this.totalVoters});
  CustomMethods _customMethods = CustomMethods();
  double calculateVotePercentage(){
    return totalVoters==0?0:(election.votes/totalVoters)*100;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Countdown till the election'),
        election.startDate.difference(DateTime.now()).inSeconds>0?Center(child: StartDateCountdown(startDate: election.startDate,)):SizedBox(),
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
              center: new Text(calculateVotePercentage().toString()+"%"),
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
          percent: _customMethods.calculatePercent(election),
          animationDuration: 1000,
          animation: true,
          backgroundColor: Colors.grey,
          progressColor: Colors.pink,
        ),
      ],
    );
  }
}
