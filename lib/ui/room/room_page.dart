import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter1/common/bloc/room_bloc.dart';

class RoomPage extends StatefulWidget {
  RoomPage(this.roomBlock, {Key key, this.title}): super(key: key);

  final RoomBloc roomBlock;
  final String title;

  bool isContinuousOn = false;
  TextEditingController _textFieldController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  @override
  void initState() {
    super.initState();

    widget.roomBlock.initNotifications();

    widget.roomBlock.messageStream.listen((message) =>
    {
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
  }

  @override
  Widget build(BuildContext context) {

    widget.roomBlock.roomId = ModalRoute.of(context).settings.arguments;

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
          _eventList(true),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("One time questions",
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
            ),
          ),
          _eventList(false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabClick,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _eventList(bool continuous){
    return StreamBuilder(
      stream: continuous
        ? widget.roomBlock.continuousEventsStream()
        : widget.roomBlock.questionEventsStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return _listViewBuilder(snapshot.data, continuous, context);
        } else if (snapshot.hasError) {
          return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Error has occured"),
              )
          );
        }
        return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("No events"),
            )
        );
      },
    );
  }

  Widget _listViewBuilder(QuerySnapshot response, bool continuous, BuildContext context){
    return Container(
      height: response.documents.length * 76.0 > (MediaQuery.of(context).size.height / 2.0)
          ? ((MediaQuery.of(context).size.height / 2.5) / 76.0).floor() * 76.0
          : response.documents.length * 76.0,
      child: ListView.separated(
          itemCount: response.documents.length,
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          itemBuilder: (BuildContext context, int index) =>
            continuous
              ? _continuousEventCell(response.documents[index])
              : _questionEventCell(response.documents[index]),
          separatorBuilder: (BuildContext context, int index) =>
            const Divider()),
    );
  }

  Widget _continuousEventCell(DocumentSnapshot item) {

    var icons = Icons.event;

    switch(item['type']){
      case 1:
        icons = Icons.gps_fixed;
        break;
      case 2:
        icons = Icons.wifi;
        break;
      case 3:
        icons = Icons.bluetooth;
    }

    var titleWidgets = <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Icon(icons),
      ),
      Text(item['name'],
        style: TextStyle(fontSize: 18.0),
      ),
    ];

    if(item['type'] == 0) titleWidgets.removeAt(0);

    return Container(
      height: 60.0,
      child: InkWell(
        onTap: () {widget.roomBlock.toggleTakingEvent(item);},
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: titleWidgets
                  ),
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: (item['responderList'] as List<dynamic>)
                        .map((f) => _usersIcons(f)).toList(),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionEventCell(DocumentSnapshot item) {

    var titleWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text((item['responderList'] as List<dynamic>).length.toString()
                + "/" + item['minAccepted'].toString()
        ),
      ),
      Text(item['name'],
        style: TextStyle(fontSize: 18.0),
      ),
    ];

    if(item['minAccepted'] == -1) titleWidgets.removeAt(0);

    if(item['type'] == 0){
      return Container(
        height: 60.0,
        child: InkWell(
          onTap: () {widget.roomBlock.toggleTakingEvent(item);},
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: titleWidgets
                  ),
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: (item['responderList'] as List<dynamic>)
                          .map((f) => _usersIcons(f)).toList(),
                    )
                ),
              ],
            ),
          ),
        ),
      );
    } else {

      var widgets = <Widget>[];

      widgets.add(InkWell(
        child: Text("Yes:", style: TextStyle(color: Colors.green)),
        onTap: () {widget.roomBlock.toggleTakingEvent(item, yes: true);},
      ));

      widgets.addAll((item['responderList'] as List<dynamic>)
          .where((test) => test['yes'])
          .map((f) => _usersIcons(f)).toList());

      widgets.add(InkWell(
        child: Text("No:", style: TextStyle(color: Colors.red)),
        onTap: () {widget.roomBlock.toggleTakingEvent(item, yes: false);},
      ));

      widgets.addAll((item['responderList'] as List<dynamic>)
          .where((test) => !test['yes'])
          .map((f) => _usersIcons(f)).toList());


      return Container(
        height: 60.0,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: titleWidgets
                ),
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widgets,
                  ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _usersIcons(dynamic responder) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
          backgroundImage: NetworkImage(
            responder['imgUrl']
          ),
      ),
    );
  }

  void _onFabClick() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Continous event", style: TextStyle(fontSize: 14)),
                    Switch(
                      value: widget.isContinuousOn,
                      onChanged: (bool isOn){
                        setState(() {
                          widget.isContinuousOn = isOn;
                        });
                      },
                    ),
                    Text("Question", style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: widget._textFieldController,
                  decoration: InputDecoration(hintText: "Event name"),
                  onFieldSubmitted: (input) {
                    if(input.isEmpty) return;
                    widget.roomBlock.createNewContinuousEvent(input);
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Add'),
                onPressed: () {
                  if(widget._textFieldController.text.isEmpty) return;

                  if(widget.isContinuousOn){
                    widget.roomBlock.createNewContinuousEvent(
                        widget._textFieldController.text);
                  } else {
                    widget.roomBlock.createNewQuestionEvent(
                        widget._textFieldController.text);
                  }

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}