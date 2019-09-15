import 'package:flutter/material.dart';
import 'package:flutter1/di/common_injector.dart';
import 'package:flutter1/ui/chat/chat_page.dart';
import 'package:flutter1/ui/login/login_page.dart';
import 'package:flutter1/ui/room/room_page.dart';
import 'package:inject/inject.dart';
import 'package:flutter/rendering.dart';

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
      home: RoomPage(commonInjector.roomBloc, title: 'My room', args: "globalRoom"),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) =>
            LoginPage(commonInjector.loginBloc, title: 'Firebase login'),
        '/chat': (BuildContext context) =>
            ChatPage(commonInjector.chatBloc, title: 'Chat'),
      },
    );
  }
}