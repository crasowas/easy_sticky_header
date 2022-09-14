import 'package:easy_sticky_header/easy_sticky_header.dart';
import 'package:flutter/material.dart';

class Example12 extends StatelessWidget {
  const Example12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: const Text('Infinite list'),
      ),
      body: StickyHeader(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemBuilder: (context, index) {
            if (index % 3 == 0 && index < 6) {
              return StickyContainerWidget(
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
