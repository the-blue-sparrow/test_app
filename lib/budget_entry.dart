import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Entry extends StatefulWidget {
  final id;

  Entry(this.id);
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  List category = [];
  int i = 0;
  bool t = true;
  Map budgetData;

  Future<String> _setData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = json.encode(map);
    prefs.setString("data", counter);

    return counter;
  }

  Future<String> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter =
        (prefs.getString('data') ?? json.encode({widget.id.toString(): Map()}));
    return counter;
  }

  @override
  void initState() {
    _getData().then((String value) {
      this.budgetData = json.decode(value);

      this.category = this
          .budgetData[widget.id.toString()]
          .values
          .toList()
          .reversed
          .toList();
      if (this.category.length != 0) {
        this.i = int.parse(this
            .category[0]
            .toString()[this.category.last.toString().length - 1]);
      }
      print('${this.budgetData}');
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Map data for each id

    ///    setting initial value

    print(category);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xffb22020),
        title: Text(
          'Travel',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
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
                    'Total for ${widget.id}',
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
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
//                        itemCount: category.length,
                        itemCount: category.length,
//                            budget_data[widget.id.toString()].values.length,

                        itemBuilder: (context, index) {
                          final item = category[index].toString();
                          print(
                              'hello $item ${widget.id.toString()} $budgetData');
                          budgetData[widget.id.toString()][item] = item;

                          _setData(budgetData).then((value) {
                            // setState(() {});
                            print(value.runtimeType);
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

                              var temp = category[index];

                              budgetData[widget.id.toString()]
                                  .remove(temp.toString());
                              category.remove(temp);

                              print('$temp, $index');
                              print(budgetData[widget.id.toString()]);

                              _setData(budgetData).then((value) {
                                setState(() {});
                                print(value.runtimeType);
                              });

                              // Then show a snackbar.
                            },
                            // Show a red background as the item is swiped away.
//                  background: Container(color: Colors.red),
                            child: Card(
                              child: ListTile(
                                title: Container(
                                  child: Column(
                                    children: [
                                      RaisedButton(
                                        child: TextFormField(
                                          onTap: () {
                                            t = false;
                                            print(t);
                                            setState(() {});
                                          },
                                          enabled: t,
                                          initialValue: '$item',
                                        ),
                                        onPressed: () {
                                          t = true;
                                          print(t);
                                          setState(() {});
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                            child: Text('+new item'),
                                            onPressed: () {},
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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
                    '+new category',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      i++;
                      category.insert(0, 'Category $i');
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
