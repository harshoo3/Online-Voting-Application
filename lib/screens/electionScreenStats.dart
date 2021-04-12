import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customMethods.dart';
import 'package:online_voting/models/electionClass.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class ElectionScreenStats extends StatelessWidget {

  ElectionClass election;
  ElectionScreenStats({this.election});
  CustomMethods _customMethods = CustomMethods();
  @override
  Widget build(BuildContext context) {
    return Column(
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
