import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

import '../test_config.dart';

class Example6 extends StatefulWidget {
  const Example6({Key? key}) : super(key: key);

  @override
  State<Example6> createState() => _Example6State();
}

class _Example6State extends State<Example6>
    with SingleTickerProviderStateMixin {
  final int parentIndex = 2;
  final List<int> _groupedIndexList = [3, 6, 15, 26];
  late final StickyHeaderController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = StickyHeaderController();
    _tabController = TabController(
      length: _groupedIndexList.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Building header widget by group'),
      ),
      body: StickyHeader(
        controller: _controller,
        child: ListView.builder(
          reverse: TestConfig.reverse,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: 50,
          itemBuilder: (context, index) {
            if (index == parentIndex) {
              return _buildParentHeader1(index);
              // return _buildParentHeader2(index);
            } else if (_groupedIndexList.contains(index)) {
              return _buildChildHeader1(index, parentIndex);
              // return _buildChildHeader2(index, parentIndex);
            }
            return _buildItem(index);
          },
        ),
      ),
    );
  }

  /// Building parent header widget is not limited to using
  /// [ParentStickyContainerBuilder], [StickyContainerWidget] or
  /// [StickyContainerBuilder] can also be used.
  Widget _buildParentHeader1(int index) => ParentStickyContainerBuilder(
        index: index,
        onUpdate: (childStickyHeaderInfo) {
          if (childStickyHeaderInfo != null &&
              _groupedIndexList.indexOf(childStickyHeaderInfo.index) !=
                  _tabController.index) {
            _tabController.animateTo(
                _groupedIndexList.indexOf(childStickyHeaderInfo.index));
          }
          // There is no need to rebuild the [TabBar] here, so return false.
          return false;
        },
        builder: (context, childStickyHeaderInfo) {
          return Container(
            color: Colors.purple,
            width: double.infinity,
            height: 80,
            child: TabBar(
              controller: _tabController,
              tabs: _groupedIndexList
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        // If this just happens to jump to the header widget of
                        // the specified index, the header widget doesn't become
                        // a sticky header at this point, which is why you need
                        // to set a little offset.
                        _controller.animateTo(e, offset: 0.5);
                      },
                      child: Text(
                        'Header #$e',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          );
        },
      );

  Widget _buildParentHeader2(int index) => ParentStickyContainerBuilder(
        index: index,
        builder: (context, childStickyHeaderInfo) {
          return Container(
            color: Colors.purple,
            width: double.infinity,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _groupedIndexList.map(
                (e) {
                  return GestureDetector(
                    onTap: () {
                      _controller.animateTo(e, offset: 0.5);
                    },
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Header #$e',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(
                            height: 2,
                            thickness: 2,
                            color: (childStickyHeaderInfo?.index == e)
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          );
        },
      );

  Widget _buildChildHeader1(int index, int parentIndex) =>
      StickyContainerWidget(
        index: index,
        parentIndex: parentIndex,
        // It is recommended to use the default value, which is more in line
        // with usage habits.
        overlapParent: false,
        child: Container(
          color: Colors.green,
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

  Widget _buildChildHeader2(int index, int parentIndex) =>
      StickyContainerBuilder(
        index: index,
        parentIndex: parentIndex,
        builder: (context, stickyAmount) => Container(
          color: Colors.green,
          padding: const EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 50,
          child: Text(
            'Header #$index stickyAmount: ${stickyAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );

  Widget _buildItem(int index) => Column(
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
}
