import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/nested_list.dart';

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
  Map budgetSum;

  double indiSum(Map map) {
    List l1 = map[widget.id].keys.toList();
    List sum = [];
    for (String i in l1) {
      List l2 = map[widget.id][i]['entry'].keys.toList();
      for (String j in l2) {
        sum.add(map[widget.id][i]['entry'][j]['value']);
      }
    }
    double val = sum.fold(0, (previous, current) => previous + current);
    print(val);
    return val;
  }

  Future<String> setSumData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = json.encode(map);
    prefs.setString("sum", counter);

    return counter;
  }

  Future<String> getSumData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = (prefs.getString('sum') ?? jsonEncode(Map()));
    return counter;
  }

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
      print('hellooo${this.budgetData}');
      this.budgetData[widget.id.toString()] =
          this.budgetData[widget.id.toString()] ?? Map();
      this.category =
          this.budgetData[widget.id.toString()].keys.toList().reversed.toList();
      if (this.category.length != 0) {
        this.i = int.parse(this
            .category[0]
            .toString()[this.category.last.toString().length - 1]);
      }
      print('${this.budgetData}');
      setState(() {});
    });
    getSumData().then((value) {
      this.budgetSum = jsonDecode(value);
      this.budgetSum['individual sum'] =
          this.budgetSum['individual sum'] ?? Map();

      this.budgetSum['individual sum'][widget.id] =
          this.budgetSum['individual sum'][widget.id] ?? 0.0;
//      print(' areeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${this.budgetSum}');
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSumData().then((value) {
      this.budgetSum = jsonDecode(value);
      this.budgetSum['individual sum'] =
          this.budgetSum['individual sum'] ?? Map();

      this.budgetSum['individual sum'][widget.id] =
          this.budgetSum['individual sum'][widget.id] ?? 0.0;
      print(' areeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${this.budgetSum}');
//      setState(() {});
    });
//    final Sum sum = Provider.of<Sum>(context);
//    String sum = '0.0';
//    getSumData().then((value) {
//      try {
//        sum = indiSum(jsonDecode(value)).toString();
//        print('hiiiiiiiiiiiiiiiiii$sum');
//      } catch (e) {
//        print(e);
//        sum = '0.0';
//      }
//    });

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
                        budgetSum['individual sum'][widget.id].toString() ??
                            '0.0',
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
                        shrinkWrap: true,

                        itemBuilder: (BuildContext context, int index) {
                          final item = category[index].toString();

                          List inter_items = [];
                          int iter = 0;

                          budgetData[widget.id.toString()][item] =
                              budgetData[widget.id.toString()][item] ?? Map();
                          budgetData[widget.id.toString()][item]['title'] =
                              budgetData[widget.id.toString()][item]['title'] ??
                                  item;

                          budgetData[widget.id.toString()][item]['entry'] =
                              budgetData[widget.id.toString()][item]['entry'] ??
                                  Map();
                          inter_items = budgetData[widget.id.toString()][item]
                                  ['entry']
                              .keys
                              .toList();
//                          print(
//                              'hello $item ${widget.id.toString()} ${budgetData}');

                          if (inter_items.length != 0) {
                            iter = int.parse(inter_items.last.toString()[
                                inter_items.last.toString().length - 1]);
                          }
                          if (inter_items.length != 0) {
                            iter = int.parse(inter_items[0].toString()[
                                inter_items.last.toString().length - 1]);
                          }
                          print('these are items $inter_items');

                          _setData(budgetData).then((value) {
                            // setState(() {});
                            print(value.runtimeType);
                          });
//                          setState(() {});

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
//                                print(value.runtimeType);
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
                                      FlatButton(
                                        child: TextFormField(
                                          onTap: () {
                                            t = false;
                                            print(t);
                                            setState(() {});
                                          },
                                          enabled: t,
                                          initialValue:
                                              budgetData[widget.id.toString()]
                                                      [item]['title']
                                                  .toString(),
                                          onChanged: (val) {
                                            budgetData[widget.id.toString()]
                                                [item]['title'] = val;

//                                            setState(() {});
                                            _setData(budgetData);
//                                        .then((value) => print(value));
                                          },
                                        ),
                                        onPressed: () {
                                          t = true;
                                          print(t);
                                          setState(() {});
                                        },
                                      ),
                                      ListWidget(widget.id.toString(), item),
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
