import 'package:flutter/material.dart';

import 'package:flutter1/common/bloc/room_bloc.dart';

class RoomPage extends StatefulWidget {
  RoomPage(this.roomBlock, {Key key, this.title}): super(key: key);

  final RoomBloc roomBlock;
  final String title;

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Continous events",
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("One time queries",
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}