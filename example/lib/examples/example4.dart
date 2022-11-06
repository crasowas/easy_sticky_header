import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example4 extends StatefulWidget {
  const Example4({Key? key}) : super(key: key);

  @override
  State<Example4> createState() => _Example4State();
}

class _Example4State extends State<Example4> {
  late final StickyHeaderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StickyHeaderController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title:
            const Text('Scrolls to the top after the header widget is tapped'),
      ),
      body: StickyHeader(
        controller: _controller,
        child: ListView.builder(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index % 6 == 0) {
              return StickyContainerWidget(
                index: index,
                child: GestureDetector(
                  onTap: () {
                    // Jumps without animation.
                    // _controller.jumpTo(index);
                    _controller.animateTo(index);
                  },
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
