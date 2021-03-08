import 'package:flutter/material.dart';
import 'home.dart';

int count1 = 0;
int count2 = 0;

class Voting extends StatefulWidget {
  @override
  _VotingState createState() => _VotingState();
}

class _VotingState extends State<Voting> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Party 1: $count1',
            ),
            Text(
              'Party 2: $count2',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton.icon(
              onPressed: (){
              count1=count1+1;
              },
              icon: Icon(Icons.add),
              label: Text(
                '+1'
              ),
            ),
            RaisedButton.icon(
              onPressed: (){
                count2=count2+1;
              },
              icon: Icon(Icons.add),
              label: Text(
                  '+1'
              ),
            ),
          ],
        )
      ],
    );
  }
}
