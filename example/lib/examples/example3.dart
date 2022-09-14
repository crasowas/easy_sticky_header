import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

class Example3 extends StatelessWidget {
  const Example3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('Building header widget by sticky amount'),
      ),
      body: StickyHeader(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index % 3 == 0) {
              if (index == 6) {
                return StickyContainerWidget(
                  index: index,
                  child: Container(
                    color: const Color.fromRGBO(155, 105, 0, 1),
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: min(100, 50 + 5.0 * index),
                    child: Text(
                      'Header #$index, not using stickyAmount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              } else {
                return StickyContainerBuilder(
                  index: index,
                  builder: (context, stickyAmount) => Container(
                    color: Color.fromRGBO(
                        155 + (100 * stickyAmount).toInt(), 105, 0, 1.0),
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: min(100, 50 + 5.0 * index),
                    child: Text(
                      'Header #$index  stickyAmount：${stickyAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
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
