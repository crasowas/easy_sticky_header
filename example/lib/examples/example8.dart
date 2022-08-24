import 'dart:math';

import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

class Example8 extends StatelessWidget {
  const Example8({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('SliverPersistentHeader'),
      ),
      body: StickyHeader(
        spacing: 50,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomDelegate(),
            ),
            // Temporarily only supports the layout of a header widget.
            _buildHeaderWidget(1),
            _buildSliverGrid(1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWidget(int index) => SliverToBoxAdapter(
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
                'Item #$section-$index',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          },
          childCount: 10,
        ),
      );
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 50;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: const Color.fromRGBO(0, 128, 255, 1.0),
        padding: const EdgeInsets.only(left: 16.0),
        alignment: Alignment.centerLeft,
        child: const Text(
          'SliverPersistentHeader',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}
