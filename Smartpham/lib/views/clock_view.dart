import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child:const AnalogClock.dark(
        dialColor: Color(0xFF78909C),
        dialBorderColor: Colors.blue,
        dialBorderWidthFactor: 0.04,
        markingColor: Colors.black,
        markingRadiusFactor: 1.0,
        markingWidthFactor: 1.0,
        hourNumberColor: Colors.black,
        hourNumbers: const ['', '', '3', '', '', '6', '', '', '9', '', '', '12'],
        hourNumberSizeFactor: 1.0,
        hourNumberRadiusFactor: 1.0,
        hourHandColor: Colors.black,
        hourHandWidthFactor: 1.0,
        hourHandLengthFactor: 1.0,
        minuteHandColor: Colors.black,
        minuteHandWidthFactor: 1.0,
        minuteHandLengthFactor: 1.0,
        secondHandColor: Colors.black,
        secondHandWidthFactor: 1.0,
        secondHandLengthFactor: 1.0,
        centerPointColor: Colors.black,
        centerPointWidthFactor: 1.0,

      )

    );
  }
}

