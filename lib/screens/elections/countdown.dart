import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
class StartDateCountdown extends StatefulWidget {
  DateTime startDate;
  StartDateCountdown({this.startDate});
  @override
  State<StatefulWidget> createState() => _StartDateCountdownState(startDate: startDate);
}

class _StartDateCountdownState extends State<StartDateCountdown> {
  Timer _timer;
  DateTime _currentTime;
  DateTime startDate;
  _StartDateCountdownState({this.startDate});

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = startDate.difference(_currentTime);

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;
    if(hours==0 && minutes==0 && days==0 && seconds==0){
      _timer.cancel();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(80,0,0,0),
      child: Row(
        children: [
          TextWidget(days<10?' 0$days ':' $days '),
          ColonText(),
          TextWidget(hours<10?' 0$hours ':' $hours '),
          ColonText(),
          TextWidget(minutes<10?' 0$minutes ':' $minutes '),
          ColonText(),
          TextWidget(seconds<10?' 0$seconds ':' $seconds '),
        ],
      ),
    );
  }
}
