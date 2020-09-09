import 'package:flutter/material.dart';
import 'dart:async';

class DatePicker {
  String weekday(weekday) {
    Map weekdays = {
      7: 'Sunday',
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
    };
    return weekdays[weekday];
  }

  Future<String> callDatePicker(context) async {
    String finaldate;
    var order = await getDate(context);

    finaldate =
        '${order.day}/${order.month}/${order.year}, ${weekday(order.weekday)}';
    return finaldate;
  }

  Future<DateTime> getDate(context) {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}
//
//class DatePicker extends StatefulWidget {
//  final String title = 'kire';
//  @override
//  _DatePickerState createState() => new _DatePickerState();
//}
//
//String weekday(weekday) {
//  Map weekdays = {
//    7: 'Sunday',
//    1: 'Monday',
//    2: 'Tuesday',
//    3: 'Wednesday',
//    4: 'Thursday',
//    5: 'Friday',
//    6: 'Saturday',
//  };
//  return weekdays[weekday];
//}
//
//class _DatePickerState extends State<DatePicker> {
//  String finaldate;
//
//  void callDatePicker() async {
//    var order = await getDate();
//    setState(() {
//      finaldate =
//          '${order.day}/${order.month}/${order.year}, ${weekday(order.weekday)}';
//    });
//  }
//
//  Future<DateTime> getDate() {
//    // Imagine that this function is
//    // more complex and slow.
//    return showDatePicker(
//      context: context,
//      initialDate: DateTime.now(),
//      firstDate: DateTime(2018),
//      lastDate: DateTime(2030),
//      builder: (BuildContext context, Widget child) {
//        return Theme(
//          data: ThemeData.light(),
//          child: child,
//        );
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(widget.title),
//      ),
//      body: new Center(
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(color: Colors.grey[200]),
//              padding: EdgeInsets.symmetric(horizontal: 30.0),
//              child: finaldate == null
//                  ? Text(
//                      "Use below button to Select a Date",
//                      textScaleFactor: 2.0,
//                    )
//                  : Text(
//                      "$finaldate",
//                      textScaleFactor: 2.0,
//                    ),
//            ),
//            new RaisedButton(
//              onPressed: callDatePicker,
//              color: Colors.blueAccent,
//              child:
//                  new Text('Click here', style: TextStyle(color: Colors.white)),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
