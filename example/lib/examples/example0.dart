import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

class Example0 extends StatefulWidget {
  const Example0({Key? key}) : super(key: key);

  @override
  State<Example0> createState() => _Example0State();
}

class _Example0State extends State<Example0> {
  bool _reverse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('Vertical scroll axis'),
      ),
      body: StickyHeader(
        // Not required, it only needs to be set when the [reverse] parameter
        // needs to be dynamically changed.
        reverse: _reverse,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          reverse: _reverse,
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index % 3 == 0) {
              return StickyContainerWidget(
                index: index,
                visible: index != 6,
                child: Container(
                  color: Color.fromRGBO(Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256), 1),
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    index == 6
                        ? 'Header #$index, non-sticky'
                        : 'Header #$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Item #$index',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Colors.grey.shade200,
                  indent: 16.0,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _reverse = !_reverse;
          });
        },
        child: const Text(
          'Reverse',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
