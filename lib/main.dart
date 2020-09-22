import 'package:flutter/material.dart';
import 'package:testapp/budget.dart';
import 'package:testapp/budget_entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Budget(),
        '/entry': (i) => Entry(i),
//        '/date': (context) => DatePicker(),
      },
//      home: Budget(),
    );
  }
}
