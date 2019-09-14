import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter1/common/bloc/room_bloc.dart';

class RoomPage extends StatefulWidget {
  RoomPage(this.roomBlock, {Key key, this.title}): super(key: key);

  final RoomBloc roomBlock;
  final String title;

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
          _continuousEventList(),
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
        onPressed: _onFabClick,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _continuousEventList(){
    return StreamBuilder(
      stream: widget.roomBlock.continuousEventsStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return _listViewBuilder(snapshot.data, context);
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

  Widget _listViewBuilder(QuerySnapshot response, BuildContext context){
    return Container(
      height: response.documents.length > 3
          ? 76.0 * 3
          : response.documents.length * 76.0,
      child: ListView.separated(
          itemCount: response.documents.length,
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          itemBuilder: (BuildContext context, int index) =>
            _eventRow(response.documents[index]),
          separatorBuilder: (BuildContext context, int index) =>
            const Divider()),
    );
  }

  Widget _eventRow(DocumentSnapshot item) {
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
                      children: <Widget>[
                        Text(item['name'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ]
                  )
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
            title: Text('Add new continuous event'),
            content: TextFormField(
              controller: widget._textFieldController,
              decoration: InputDecoration(hintText: "Event name"),
              onFieldSubmitted: (input) {
                if(input.isEmpty) return;
                widget.roomBlock.createNewContinuousEvent(input);
                Navigator.of(context).pop();
              }
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Add'),
                onPressed: () {
                  if(widget._textFieldController.text.isEmpty) return;
                  widget.roomBlock.createNewContinuousEvent(widget._textFieldController.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}