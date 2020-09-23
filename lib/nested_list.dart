import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ListWidget extends StatefulWidget {
  final String id;
  final String cat;
  ListWidget(this.id, this.cat);
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  List inter_items = [];
  int iter = 0;
  Map budgetData;
  Map budgetSum;

  Future<String> _setData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = json.encode(map);
    prefs.setString("data", counter);

    return counter;
  }

  Future<String> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String counter = prefs.getString('data');
    return counter;
  }

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

  @override
  void initState() {
    getSumData().then((value) {
      this.budgetSum = jsonDecode(value);
      this.budgetSum['individual sum'] =
          this.budgetSum['individual sum'] ?? Map();

      this.budgetSum['individual sum'][widget.id] =
          this.budgetSum['individual sum'][widget.id] ?? 0.0;
//      print(' areeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${this.budgetSum}');
    });
    _getData().then((value) {
      this.budgetData = jsonDecode(value);

      print(this.budgetData);
      this.budgetData[widget.id][widget.cat]['entry'] =
          this.budgetData[widget.id][widget.cat]['entry'] ?? Map();
      this.inter_items =
          this.budgetData[widget.id][widget.cat]['entry'].keys.toList();

      if (this.inter_items.length != 0) {
        this.iter = int.parse(this
            .inter_items
            .last
            .toString()[this.inter_items.last.toString().length - 1]);
      }
      print('${this.budgetData}');
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final Sum sum = Provider.of<Sum>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: inter_items.length,
                itemBuilder: (context, index) {
                  final item = inter_items[index].toString();
                  print(budgetData[widget.id][widget.cat]['entry']);
                  // if (budgetData[widget.id.toString()][item] == null) {
                  //   budgetData[widget.id.toString()][item] = Map();
                  // }

                  if (budgetData[widget.id][widget.cat]['entry'][item] ==
                      null) {
                    budgetData[widget.id][widget.cat]['entry'][item] = Map();
                  }

                  if (budgetData[widget.id][widget.cat]['entry'][item]
                          ['title'] ==
                      null) {
                    budgetData[widget.id][widget.cat]['entry'][item]['title'] =
                        'Entry $iter';
                  }

                  if (budgetData[widget.id][widget.cat]['entry'][item]
                          ['value'] ==
                      null) {
                    budgetData[widget.id][widget.cat]['entry'][item]['value'] =
                        0.0;
                  }

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

                      var temp = inter_items[index];

                      budgetData[widget.id][widget.cat]['entry']
                          .remove(temp.toString());
                      inter_items.remove(temp);

                      print('$temp, $index');
                      print(budgetData[widget.id][widget.cat]['entry']);

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
//                          color: Colors.grey,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: budgetData[widget.id]
                                      [widget.cat]['entry'][item]['title'],
                                  onChanged: (val) {
                                    budgetData[widget.id][widget.cat]['entry']
                                        [item]['title'] = val;

//                                            setState(() {});
                                    _setData(budgetData);
//                                        .then((value) => print(value));
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
//                                  onTap: () {
//                                    setState(() {});
//                                  },
                                  initialValue: budgetData[widget.id]
                                          [widget.cat]['entry'][item]['value']
                                      .toString(),
                                  onChanged: (val) {
                                    budgetData[widget.id][widget.cat]['entry']
                                        [item]['value'] = int.parse(val);
//                                    print(budgetSum['individual sum'][widget.id]
//                                        .runtimeType);
                                    budgetSum['individual sum'][widget.id] =
                                        indiSum(budgetData);
//                                    total += indiSum(budgetData);
                                    setSumData(budgetSum)
                                        .then((value) => print(value));
//                                            setState(() {});
                                    _setData(budgetData);
//                                        .then((value) => print(value));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
              child: Text('+add item'),
              onPressed: () {
                setState(() {
                  iter++;
                  inter_items.add('Category $iter');
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
