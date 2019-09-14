import 'package:flutter/material.dart';
import 'package:flutter1/di/common_injector.dart';
import 'package:inject/inject.dart';
import 'package:flutter/rendering.dart';

import 'home/home_page.dart';
import 'list/list_page.dart';

@provide
class App extends StatelessWidget {

  CommonInjector commonInjector;

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return MaterialApp(
      title: 'Flutter samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      home: HomePage(title: 'Flutter samples'),
      routes: <String, WidgetBuilder> {
        '/list': (BuildContext context) =>
            ListPage(commonInjector.stackQuestionsBloc, title: 'List page test'),
      },
    );
  }
}