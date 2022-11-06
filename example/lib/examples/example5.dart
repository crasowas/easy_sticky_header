import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example5 extends StatefulWidget {
  const Example5({Key? key}) : super(key: key);

  @override
  State<Example5> createState() => _Example5State();
}

class _Example5State extends State<Example5> {
  late final StickyHeaderController _controller;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1200);

  @override
  void initState() {
    super.initState();
    _controller = StickyHeaderController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('Jumps to the header of the specified index'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StickyHeader(
              controller: _controller,
              child: ListView.builder(
                reverse: TestConfig.reverse,
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFloatingActionButton(0),
                _buildFloatingActionButton(33),
                TextWidget(controller: _controller),
                _buildFloatingActionButton(72),
                _buildFloatingActionButton(93),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(int index) => FloatingActionButton(
        heroTag: index,
        onPressed: () {
          // If this just happens to jump to the header widget of
          // the specified index, the header widget doesn't become
          // a sticky header at this point, which is why you need
          // to set a little offset.
          _controller.animateTo(
            index,
            offset: 0.5,
            velocity: 1.5,
          );
        },
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
}

class TextWidget extends StatefulWidget {
  final StickyHeaderController controller;

  const TextWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  int? _index;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Text(
          '$_index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );

  void _update() {
    var index = widget.controller.currentStickyHeaderInfo?.index;
    if (index != _index) {
      setState(() {
        _index = index;
      });
    }
  }
}
