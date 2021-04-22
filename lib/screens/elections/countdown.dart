import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_voting/customWidgets/customClassesAndWidgets.dart';
class EndDateCountdown extends StatefulWidget {
  DateTime endDate;
  EndDateCountdown({this.endDate});
  @override
  State<StatefulWidget> createState() => _EndDateCountdownState(endDate: endDate);
}

class _EndDateCountdownState extends State<EndDateCountdown> {
  Timer _timer;
  DateTime _currentTime;
  DateTime endDate;
  _EndDateCountdownState({this.endDate});

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
    final remaining = endDate.difference(_currentTime);

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;

    return Row(
      children: [
        TextWidget(days<10?' 0$days ':' $days '),
        ColonText(),
        TextWidget(hours<10?' 0$hours ':' $hours '),
        ColonText(),
        TextWidget(minutes<10?' 0$minutes ':' $minutes '),
        ColonText(),
        TextWidget(seconds<10?' 0$seconds ':' $seconds '),
      ],
    );
  }
}
