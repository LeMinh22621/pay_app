import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pay app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _visible;
  late int _counter;
  late double _total;
  late double _tip;
  late double _percent;
  late double _enter;

  late Color _myBillColor;
  late TextEditingController _myTextFieldController;
  @override
  void initState() {
    super.initState();
    _myBillColor = Colors.black;
    _visible = false;
    _myTextFieldController = TextEditingController();

    _counter = 1;
    _total = 0.0;
    _tip = 0.0;
    _percent = 0.0;
    _enter = 0.0;
  }

  void _increaseCounter() {
    setState(() {
      _counter++;
      _tip = ((_enter * _percent / 100) * 100).floor() / 100;
      _counter = _counter <= 0 ? 1 : _counter;
      _total = ((_enter / _counter) * 100).floor() / 100 + _tip;
    });
  }

  void _decreaseCounter() {
    setState(() {
      _counter--;
      _tip = ((_enter * _percent / 100) * 100).floor() / 100;
      _counter = _counter <= 0 ? 1 : _counter;
      _total = ((_enter / _counter) * 100).floor() / 100 + _tip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.purple.withOpacity(0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Per Person",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "\$ $_total",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _myBillColor =
                          hasFocus ? Colors.purple : Colors.black);
                    },
                    child: TextFormField(
                      //controller: _myTextFieldController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixText: '\$    ',
                        labelText: "Enter Bill",
                        labelStyle: TextStyle(
                          color: _myBillColor,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          gapPadding: 4.0,
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _enter = double.parse(value);
                        } else {
                          _enter = 0;
                        }
                        setState(() {
                          if (value.isEmpty) {
                            _visible = false;
                          } else {
                            _visible = true;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _visible
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Split",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            child: IconButton(
                              icon: const Icon(
                                Icons.horizontal_rule_outlined,
                                color: Colors.black,
                                size: 35,
                              ),
                              onPressed: _decreaseCounter,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$_counter',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 35,
                              ),
                              onPressed: _increaseCounter,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _visible
                    ? Container(
                        margin: const EdgeInsets.only(left: 26),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Tip",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 180),
                            Text(
                              '\$ $_tip',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                _visible
                    ? Text(
                        "$_percent%",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 26,
                        ),
                      )
                    : Container(),
                _visible
                    ? Slider(
                        max: 100,
                        min: 0,
                        value: _percent,
                        divisions: 10,
                        label: '${_percent.floor()}',
                        onChanged: (value) {
                          setState(() {
                            _percent = (value * 100).floor() / 100;
                            _tip =
                                ((_enter * _percent / 100) * 100).floor() / 100;
                            _counter = _counter <= 0 ? 1 : _counter;
                            _total = ((_enter / _counter) * 100).floor() / 100 +
                                _tip;
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
