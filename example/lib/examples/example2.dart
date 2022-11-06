import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example2 extends StatefulWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 520);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('ScrollController with initialScrollOffset'),
      ),
      body: StickyHeader(
        child: ListView.builder(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          controller: _scrollController,
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index % 3 == 0) {
              return StickyContainerWidget(
                index: index,
                child: Container(
                  color: Color.fromRGBO(Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256), 1),
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    'Header #$index',
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
    );
  }
}
