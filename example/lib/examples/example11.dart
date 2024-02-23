import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example11 extends StatelessWidget {
  const Example11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Multiple SliverList'),
      ),
      body: StickyHeader(
        child: CustomScrollView(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          slivers: <Widget>[
            _buildSliverList(0),
            _buildSliverList(1),
            _buildSliverList(2),
            _buildSliverList(3),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverList(int section) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index % 3 == 0) {
            return StickyContainerWidget(
              // Index must be unique.
              index: section * 100 + index,
              // If you have problems with inaccurate position of sticky
              // header, please try without performance priority.
              performancePriority: false,
              child: Container(
                color: Color.fromRGBO(255 - (section * 60), 105, 0, 1.0),
                padding: const EdgeInsets.only(left: 16.0),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                child: Text(
                  'Header #$section-$index',
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
        },
        childCount: 8,
      ),
    );
  }
}
