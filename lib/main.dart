import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintPointersEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugRepaintRainbowEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {"new_page": (context) => new NewRoute()},
      home: ScrollableTabsDemo(),
      debugShowCheckedModeBanner: true,
      debugShowMaterialGrid: false,
    );
  }
}

class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("新界面"),
      ),
      body: Center(
        child: Text("新界面内容"),
      ),
    );
  }
}

class _Page {
  const _Page({this.text, this.url});

  final String text;
  final String url;
}

const List<_Page> _allPages = <_Page>[
  _Page(text: '新闻'),
  _Page(text: '娱乐'),
  _Page(text: '体育'),
  _Page(text: '财经'),
  _Page(text: '军事'),
  _Page(text: '科技'),
  _Page(text: '手机'),
  _Page(text: '数码'),
  _Page(text: '时尚'),
  _Page(text: '游戏'),
  _Page(text: '体育'),
  _Page(text: '健康'),
  _Page(text: '旅游'),
  _Page(text: '视频'),
];

class ScrollableTabsDemo extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';

  @override
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
}

class ScrollableTabsDemoState extends State<ScrollableTabsDemo>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Decoration _getIndicator() {
    return ShapeDecoration(
      shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            side: BorderSide(
              color: Colors.white70,
              width: 1.5,
            ),
          ) +
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            side: BorderSide(
              color: Colors.transparent,
              width: 8.0,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: const Text('News'),
                pinned: false,
                backgroundColor: Colors.redAccent,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  controller: _controller,
                  isScrollable: true,
                  labelColor: Colors.white,
                  indicator: _getIndicator(),
                  tabs: _allPages.map<Tab>((_Page page) {
                    return Tab(text: page.text);
                  }).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((_Page page) {
            return SafeArea(
              top: false,
              bottom: true,
              child: _PageWidget(page),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PageWidget extends StatefulWidget {
  const _PageWidget(this.page, {Key key}) : super(key: key);

  final _Page page;

  @override
  State<StatefulWidget> createState() {
    print("createState " + page.text);
    return _PageWidgetState().._refresh();
  }
}

class _PageWidgetState extends State<_PageWidget> {
  static final List<String> _items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
  ];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      print("hadRequest = true");
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scrollbar(
        child: ListView.builder(
          padding: kMaterialListPadding,
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            final String item = _items[index];
            return ListTile(
              isThreeLine: true,
              leading: CircleAvatar(child: Text(item)),
              title: Text('This item represents $item.'),
              subtitle: const Text(
                  'Even more additional list item information appears on line three.'),
            );
          },
        ),
      ),
    );
  }
}
