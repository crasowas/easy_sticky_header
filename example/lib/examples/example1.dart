import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

class Example1 extends StatelessWidget {
  const Example1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('Horizontal scroll axis'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildListView(),
          _buildListView(reverse: true),
        ],
      ),
    );
  }

  Widget _buildListView({
    bool reverse = false,
  }) =>
      Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.shade100,
        child: StickyHeader(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            scrollDirection: Axis.horizontal,
            reverse: reverse,
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
                    width: 50,
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
              return Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 200,
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 16),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Item #$index',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: Colors.grey.shade200,
                  ),
                ],
              );
            },
          ),
        ),
      );
}
