import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
Dio dio = Dio();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News Demo',
      home: ScrollableTabsDemo(),
      debugShowCheckedModeBanner: true,
      debugShowMaterialGrid: false,
    );
  }
}

class _Page {
  _Page({this.text, this.key})
      : this.url =
            "https://3g.163.com/touch/reconstruct/article/list/$key/0-20.html";
  final String text;
  final String key;
  final String url;
  final List<_News> list = List();

  Future _request() async {
    Response response = await dio.get(url);
    String value = response.toString();
    value = value.substring(9, value.length - 1);
    Map<String, dynamic> map = json.decode(value);
    List data = map[key];
    list.clear();
    data.forEach((value) {
      list.add(_News.fromJson(value));
    });
    return response;
  }
}

class _News {
  final String title;
  final String url;
  final String image;
  final String digest;
  final String time;

  _News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"],
        image = json["imgsrc"],
        digest = json["digest"],
        time = json["ptime"];
}

List<_Page> _allPages = <_Page>[
  _Page(text: '新闻', key: "BBM54PGAwangning"),
  _Page(text: '娱乐', key: "BA10TA81wangning"),
  _Page(text: '体育', key: "BA8E6OEOwangning"),
  _Page(text: '财经', key: "BA8EE5GMwangning"),
  _Page(text: '军事', key: "BAI67OGGwangning"),
  _Page(text: '科技', key: "BA8D4A3Rwangning"),
  _Page(text: '手机', key: "BAI6I0O5wangning"),
  _Page(text: '数码', key: "BAI6JOD9wangning"),
  _Page(text: '时尚', key: "BA8F6ICNwangning"),
  _Page(text: '游戏', key: "BAI6RHDKwangning"),
  _Page(text: '教育', key: "BA8FF5PRwangning"),
  _Page(text: '健康', key: "BDC4QSV3wangning"),
  _Page(text: '旅游', key: "BEO4GINLwangning"),
];

class ScrollableTabsDemo extends StatefulWidget {
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
                backgroundColor: Colors.red,
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
    return _PageWidgetState();
  }
}

class _PageWidgetState extends State<_PageWidget> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future _refreshData() async {
    Response response = await widget.page._request();
    setState(() {});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      child: Scrollbar(
        child: ListView.builder(
          padding: kMaterialListPadding,
          itemCount: widget.page.list.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WebviewScaffold(
                      appBar: AppBar(
                        title: Text("详情"),
                        backgroundColor: Colors.red,
                      ),
                      url: widget.page.list[index].url);
                }));
              },
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0)
                            ]),
                        child: Image.network(
                          widget.page.list[index].image,
                          width: 140,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(widget.page.list[index].title),
                                      Text(
                                        widget.page.list[index].digest,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        widget.page.list[index].time,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 8.0,
                                        ),
                                      )
                                    ],
                                  ))))
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
