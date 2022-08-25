import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import 'examples/example0.dart';
import 'examples/example1.dart';
import 'examples/example10.dart';
import 'examples/example2.dart';
import 'examples/example3.dart';
import 'examples/example4.dart';
import 'examples/example5.dart';
import 'examples/example6.dart';
import 'examples/example7.dart';
import 'examples/example8.dart';
import 'examples/example9.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Sticky Header Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Easy Sticky Header Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: StickyHeader(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader(index, 'Getting Started');
            } else if (index == 1) {
              return _buildItem(index, 'Example 0 - Vertical scroll axis',
                  () => _push(context, const Example0()));
            } else if (index == 2) {
              return _buildItem(index, 'Example 1 - Horizontal scroll axis',
                  () => _push(context, const Example1()));
            } else if (index == 3) {
              return _buildItem(
                  index,
                  'Example 2 - ScrollController with initialScrollOffset',
                  () => _push(context, const Example2()));
            } else if (index == 4) {
              return _buildItem(
                  index,
                  'Example 3 - Building header widget by sticky amount',
                  () => _push(context, const Example3()));
            } else if (index == 5) {
              return _buildItem(index, 'Example 4 - Infinite list',
                  () => _push(context, const Example4()));
            } else if (index == 6) {
              return _buildItem(index, 'Example 5 - Multiple SliverList',
                  () => _push(context, const Example5()));
            } else if (index == 7) {
              return _buildHeader(index, 'More features');
            } else if (index == 8) {
              return _buildItem(index, 'Example 6 - GridView',
                  () => _push(context, const Example6()));
            } else if (index == 9) {
              return _buildItem(index, 'Example 7 - SingleChildScrollView',
                  () => _push(context, const Example7()));
            } else if (index == 10) {
              return _buildItem(index, 'Example 8 - SliverPersistentHeader',
                  () => _push(context, const Example8()));
            } else if (index == 11) {
              return _buildItem(
                  index,
                  'Example 9 - Scrolls to the top after the header widget is tapped',
                  () => _push(context, const Example9()));
            } else if (index == 12) {
              return _buildItem(
                  index,
                  'Example 10 - Jumps to the header widget of the specified index',
                  () => _push(context, const Example10()));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(int index, String title) => StickyContainerWidget(
        index: index,
        child: Container(
          color: Colors.grey.shade600,
          padding: const EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 45,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      );

  Widget _buildItem(int index, String title, GestureTapCallback? onTap) =>
      Column(
        children: <Widget>[
          ListTile(
            tileColor: Colors.white,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onTap: onTap,
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey.shade200,
            indent: 16.0,
          ),
        ],
      );

  void _push(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }
}
