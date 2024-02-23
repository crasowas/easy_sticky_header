# easy_sticky_header

[![platform](https://img.shields.io/badge/platform-Flutter-blue.svg?logo=flutter)](https://flutter.dev)
[![pub](https://img.shields.io/pub/v/easy_sticky_header.svg)](https://pub.dev/packages/easy_sticky_header)
[![license](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![issues](https://img.shields.io/github/issues/crasowas/easy_sticky_header?logo=github)](https://github.com/crasowas/easy_sticky_header/issues)
[![commits](https://img.shields.io/github/last-commit/crasowas/easy_sticky_header?logo=github)](https://github.com/crasowas/easy_sticky_header/commits)

## English | [中文](https://github.com/crasowas/easy_sticky_header/blob/main/README-CN.md)

An easy-to-use and powerful sticky header for any widget that supports scrolling.

## Features

* Support widget for horizontal or vertical scrolling
* Support widget for reverse scrolling
* Allow dynamic building of header widget and support custom transition animation
* Header widget can dynamically change stickiness
* Support jumping to the header widget of the specified index
* Support header widget grouping
* Support infinite list

## Usage

Add dependency:

```yaml
dependencies:
  easy_sticky_header: ^1.1.1
```

Import package:

```dart
import 'package:easy_sticky_header/easy_sticky_header.dart';
```

Example:

```dart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          // Custom header widget.
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
          // Custom item widget.
          return Container(
            width: double.infinity,
            height: 80,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
```

For more features, please go to the [example project](https://github.com/crasowas/easy_sticky_header/blob/main/example) to see the details.

## Screenshots

|![screenshot1](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot1.gif)|![screenshot2](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot2.gif)|![screenshot3](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot3.gif)|
|:---:|:---:|:---:|
|![screenshot4](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot4.gif)|![screenshot5](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot5.gif)|![screenshot6](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot6.gif)|
|![screenshot7](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot7.gif)|![screenshot8](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot8.gif)|![screenshot9](https://github.com/crasowas/easy_sticky_header/raw/main/screenshots/screenshot9.gif)|

## Contribution

You are welcome to contribute here 😄!

You can open an [issue](https://github.com/crasowas/easy_sticky_header/issues), if you find a bug,
or want a new feature.

You can open up a PR, if you fixed a bug or implemented a new feature.

## License

```
MIT License

Copyright (c) 2022 crasowas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 ```