import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/budget_entry.dart';
import 'package:testapp/datepicker.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  List items = [];
  int i = 0;
  Map date = {};
  Future<String> _setData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = json.encode(map);
    prefs.setString("date", counter);

    return counter;
  }

  Future<String> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = (prefs.getString('date') ?? '${Map()}');
    return counter;
  }

  String subtitle(item) {
    String text;
    if (date[item] != null) {
      text = date[item].toString();
    } else {
      text = 'Select Date';
    }

    return text;
  }

  @override
  void initState() {
    _getData().then((value) {
      this.date = json.decode(value);
      this.items = this.date.keys.toList().reversed.toList();
      this.i = int.parse(
          this.items[0].toString()[this.items.last.toString().length - 1]);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xffb22020),
        title: Text(
          'Travel',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
//          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              width: double.maxFinite,
              color: Colors.amberAccent,
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.45,
                        ),
                      ),
                      Text('Tk.'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '0.00',
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          date[item] = subtitle(item);
//                          print(date);
                          _setData(date).then((value) {
                            // setState(() {});
//                            print(value.runtimeType);
                          });

                          return Dismissible(
                            // Each Dismissible must contain a Key. Keys allow Flutter to
                            // uniquely identify widgets.
                            key: UniqueKey(),
//                      Key(item)
                            // Provide a function that tells the app
                            // what to do after an item has been swiped away.
                            onDismissed: (direction) {
                              // Remove the item from the data source.
                              var temp = items[index];
                              date.remove(temp);
                              items.remove(temp);

                              // print('hi ${items[index]}');
//                              print('$date,\n $temp');

//                        items.removeAt(index);

                              _setData(date).then((value) {
                                setState(() {});
//                                print(value.runtimeType);
                              });

                              // Then show a snackbar.
                            },
                            // Show a red background as the item is swiped away.
//                  background: Container(color: Colors.red),
                            child: Card(
                              child: ListTile(
                                onTap: () async {
                                  if (date[item] == 'Select Date') {
                                    date[item] = await DatePicker()
                                        .callDatePicker(context);
//                                    print(date[item].toString());
                                    setState(() {});
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Entry(item),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Entry(item)));
                                  }
                                },
                                onLongPress: () async {
                                  date[item] = await DatePicker()
                                      .callDatePicker(context);
//                                  print(date[item].toString());
                                  setState(() {});
                                },
                                subtitle: Text(subtitle(item)),
                                title: Text('$item'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 0.65,
                child: RaisedButton(
                  color: Colors.redAccent,
                  child: Text(
                    '+new date',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      i++;
                      items.insert(0, 'Day $i');
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
