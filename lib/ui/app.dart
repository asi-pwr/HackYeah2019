import 'package:flutter/material.dart';
import 'package:flutter1/di/common_injector.dart';
import 'package:flutter1/ui/login/login_page.dart';
import 'package:flutter1/ui/room/room_page.dart';
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

    commonInjector.mainBloc.messageStream.listen((message) => {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
      )
    });

    return MaterialApp(
      title: 'Flutter samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      home: HomePage(title: 'Flutter samples'),
      routes: <String, WidgetBuilder> {
        '/test': (BuildContext context) =>
            ListPage(),
        '/login': (BuildContext context) =>
            LoginPage(commonInjector.loginBloc, title: 'Firebase login'),
        '/room': (BuildContext context) =>
            RoomPage(commonInjector.roomBloc, title: 'My room'),
      },
    );
  }
}