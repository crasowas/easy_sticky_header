import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example9 extends StatelessWidget {
  const Example9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('SingleChildScrollView'),
      ),
      body: StickyHeader(
        child: SingleChildScrollView(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Column(
            children: <Widget>[
              _buildHeader(0),
              _buildItem(0, 0),
              _buildItem(0, 1),
              _buildHeader(1),
              _buildItem(1, 0),
              _buildItem(1, 1),
              _buildItem(1, 2),
              _buildItem(1, 3),
              _buildItem(1, 4),
              _buildHeader(2),
              _buildItem(2, 0),
              _buildItem(2, 1),
              _buildItem(2, 2),
              _buildItem(2, 3),
              _buildItem(2, 4),
              _buildItem(2, 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int index) => StickyContainerWidget(
        index: index,
        child: Container(
          color: const Color.fromRGBO(255, 105, 0, 1.0),
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

  Widget _buildItem(int section, int index) => Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 80,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Item #$section-$index',
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
}
