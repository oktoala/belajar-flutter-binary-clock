import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.black38, fontSize: 30),
        ),
        fontFamily: 'Alasti',
      ),
      home: Scaffold(
        body: Clock(),
      ),
    );
  }
}


class BinaryTime {

  List<String> binaryInt;

  BinaryTime(){
    DateTime now = DateTime.now();
    String hhmmss = DateFormat("Hms").format(now).replaceAll(':', '');

    binaryInt = hhmmss
      .split('')
      .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
      .toList();
  }
  get hourTens => binaryInt[0];
  get hourOnes => binaryInt[1];
  get minuteTens => binaryInt[2];
  get minuteOnes => binaryInt[3];
  get secondTens => binaryInt[4];
  get secondOnes => binaryInt[5];


}

class Clock extends StatefulWidget {

  Clock({Key key}) : super(key: key);
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  BinaryTime _now = BinaryTime();

  @override
  void initState(){
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
              _now = BinaryTime();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClockColumn(
            binaryInt: _now.hourTens,
            title: 'H',
            color: Colors.blue,
            rows: 2,
          ),
          ClockColumn(
            binaryInt: _now.hourOnes,
            title: 'h',
            color: Colors.lightBlue,
          ),
          ClockColumn(
            binaryInt: _now.minuteTens,
            title: 'M',
            color: Colors.green,
            rows: 3,
          ),
          ClockColumn(
            binaryInt: _now.minuteOnes,
            title: 'm',
            color: Colors.lightGreen,
          ),
          ClockColumn(
            binaryInt: _now.secondTens,
            title: 'S',
            color: Colors.pink,
            rows: 3,
          ),
          ClockColumn(
            binaryInt: _now.secondOnes,
            title: 's',
            color: Colors.pinkAccent,
          ),
      ],),

    );
  }
}


/// Column to represent a binary integer.
class ClockColumn extends StatelessWidget {
  final String binaryInt;
  final String title;
  final Color color;
  final int rows;
  List bits;

  ClockColumn({this.binaryInt, this.title, this.color, this.rows = 4}) {
    bits = binaryInt.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...[
          Container(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ],
        ...bits.asMap().entries.map((entry) {
          int idx = entry.key;
          String bit = entry.value;

          bool isActive = bit == '1';
          int binaryCellValue = pow(2, 3 - idx);

          return AnimatedContainer(
            duration: Duration(milliseconds: 475),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: isActive
                  ? color
                  : idx < 4 - rows
                      ? Colors.white.withOpacity(0)
                      : Colors.black38,
            ),
            margin: EdgeInsets.all(4),
            child: Center(
              child: isActive
                  ? Text(
                      binaryCellValue.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInt, radix: 2).toString(),
            style: TextStyle(fontSize: 30, color: color),
          ),
          Container(
            child: Text(
              binaryInt,
              style: TextStyle(fontSize: 15, color: color),
            ),
          )
        ]
      ],
    );
  }
}