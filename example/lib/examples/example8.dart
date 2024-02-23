import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example8 extends StatelessWidget {
  const Example8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('CustomScrollView'),
      ),
      body: StickyHeader(
        child: CustomScrollView(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          slivers: <Widget>[
            _buildHeader(0),
            _buildSliverGrid(0),
            _buildHeader(1),
            _buildSliverGrid(1),
            _buildSliverList(1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int index) => SliverToBoxAdapter(
        child: StickyContainerWidget(
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
        ),
      );

  Widget _buildSliverList(int section) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 80,
                color: Color.fromRGBO(Random().nextInt(256),
                    Random().nextInt(256), Random().nextInt(256), 1),
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'List Item #$section-$index',
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
        childCount: 8,
      ),
    );
  }

  Widget _buildSliverGrid(int section) => SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              width: double.infinity,
              height: 80,
              color: Color.fromRGBO(Random().nextInt(256),
                  Random().nextInt(256), Random().nextInt(256), 1),
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                'Grid Item #$section-$index',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          },
          childCount: 4,
        ),
      );
}
